NAME = bwshrink
CC = gcc
FLAGS = -std=c99 -pedantic -g
FLAGS+= -Wall -Wno-unused-parameter -Wextra -Werror=vla -Werror
VALGRIND = --show-leak-kinds=all --track-origins=yes --leak-check=full
CMD = ./$(NAME)

BIND = bin
OBJD = obj
SRCD = src
RESD = res

INCL = -I$(SRCD)
SRCS = $(SRCD)/bwshrink.c
SRCS_OBJS := $(patsubst %.c,$(OBJD)/%.o,$(SRCS))

# aliases
.PHONY: final
final: $(BIND)/$(NAME)

# generic compiling command
$(OBJD)/%.o: %.c
	@echo "building object $@"
	@mkdir -p $(@D)
	@$(CC) $(INCL) $(FLAGS) -c -o $@ $<

# final executable
$(BIND)/$(NAME): $(SRCS_OBJS) $(FINAL_OBJS)
	@echo "compiling executable $@"
	@mkdir -p $(@D)
	@$(CC) -o $@ $^ $(LINK)

run:
	@cd $(BIND) && $(CMD) ../$(RESD)/font_big.data ../$(RESD)/font_big.bin 228 256

# tools
leak: leakgrind
leakgrind: $(BIND)/$(NAME)
	@rm -f valgrind.log
	@cd $(BIND) && valgrind $(VALGRIND) 2> ../valgrind.log $(CMD)
	@less valgrind.log

clean:
	@echo "cleaning"
	@rm -rf $(BIND) $(OBJD) valgrind.log

remotes:
	@echo "registering remotes"
	@git remote add github git@github.com:nullgemm/$(NAME).git
	@git remote add gitea ssh://git@git.nullgemm.fr:2999/nullgemm/$(NAME).git

github:
	@echo "sourcing submodules from https://github.com"
	@cp .github .gitmodules
	@git submodule sync
	@git submodule update --init --remote

gitea:
	@echo "sourcing submodules from personal server"
	@cp .gitea .gitmodules
	@git submodule sync
	@git submodule update --init --remote
