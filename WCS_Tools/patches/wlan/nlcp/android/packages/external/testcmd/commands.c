#include <stdbool.h>
#include <errno.h>
#include <net/if.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>

#include "iw.h"

SECTION(get);
SECTION(set);

enum wl1271_tm_commands {
	WL1271_TM_CMD_UNSPEC,
	WL1271_TM_CMD_TEST,
	WL1271_TM_CMD_INTERROGATE,
	WL1271_TM_CMD_CONFIGURE,
	WL1271_TM_CMD_NVS_PUSH,
	WL1271_TM_CMD_SET_PLT_MODE,
	WL1271_TM_CMD_RECOVER,

	__WL1271_TM_CMD_AFTER_LAST
};

enum wl1271_tm_attrs {
	WL1271_TM_ATTR_UNSPEC,
	WL1271_TM_ATTR_CMD_ID,
	WL1271_TM_ATTR_ANSWER,
	WL1271_TM_ATTR_DATA,
	WL1271_TM_ATTR_IE_ID,
	WL1271_TM_ATTR_PLT_MODE,

	__WL1271_TM_ATTR_AFTER_LAST
};

static int handle_nvs(struct nl80211_state *state,
			struct nl_cb *cb,
			struct nl_msg *msg,
			int argc, char **argv)
{
	char *end;
	void *map = MAP_FAILED;
	int fd, retval=0;
	struct nlattr *key;
	struct stat filestat;

	if (argc != 1)
		return 1;

	fd = open(argv[0], O_RDONLY);
	if (fd < 0) {
		perror("Error opening file for reading");
		return 1;
	}

	if (fstat(fd, &filestat) < 0) {
		perror("Error stating file");
		return 1;
	}

	map = mmap(0, filestat.st_size, PROT_READ, MAP_SHARED, fd, 0);
	if (map == MAP_FAILED) {
		perror("Error mmapping the file");
		goto nla_put_failure;
	}
	
	key = nla_nest_start(msg, NL80211_ATTR_TESTDATA);
	if (!key)
		goto nla_put_failure;

	NLA_PUT_U32(msg, WL1271_TM_ATTR_CMD_ID, WL1271_TM_CMD_NVS_PUSH);
	NLA_PUT(msg, WL1271_TM_ATTR_DATA, filestat.st_size, map);			
	
	nla_nest_end(msg, key);
	
	goto cleanup;

nla_put_failure:
	retval = -ENOBUFS;

cleanup:
	if (map != MAP_FAILED)
		munmap(map, filestat.st_size);

	close(fd);

	return retval;
}

static int handle_recover(struct nl80211_state *state,
			struct nl_cb *cb,
			struct nl_msg *msg,
			int argc, char **argv)
{
	int retval=0;
	struct nlattr *key;

	if (argc != 0)
		return 1;
	
	key = nla_nest_start(msg, NL80211_ATTR_TESTDATA);
	if (!key)
		goto nla_put_failure;

	NLA_PUT_U32(msg, WL1271_TM_ATTR_CMD_ID, WL1271_TM_CMD_RECOVER);
	
	nla_nest_end(msg, key);
	
	goto cleanup;

nla_put_failure:
	retval = -ENOBUFS;

cleanup:
	return retval;
}

COMMAND(set, nvs, "<nvs filename>",
	NL80211_CMD_TESTMODE, 0, CIB_PHY, handle_nvs,
	"Set nvs file");

__COMMAND(NULL, recover, "recover", NULL,
	NL80211_CMD_TESTMODE, 0, 0, CIB_PHY, handle_recover,
	"Recover");

