# Embedded tools common build rules
# Author: Stefan Misik (stefan.misik@tescan.com)

################################################################################
# Commands
################################################################################

ifeq ($(BUILDENV),windows)
    MKDIR = mkdir
else
    MKDIR = mkdir
endif

# Select the toolchain
ifneq ($(TOOLCHAIN_PREFIX),)
AR      = $(TOOLCHAIN_PREFIX)-ar
AS      = $(TOOLCHAIN_PREFIX)-as
CC      = $(TOOLCHAIN_PREFIX)-gcc
CXX     = $(TOOLCHAIN_PREFIX)-g++
OCP     = $(TOOLCHAIN_PREFIX)-objcopy
SZ      = $(TOOLCHAIN_PREFIX)-size
WINDRES = $(TOOLCHAIN_PREFIX)-windres
STRIP   = $(TOOLCHAIN_PREFIX)-strip
else
AR      = ar
AS      = as
CC      = gcc
CXX     = g++
OCP     = objcopy
SZ      = size
WINDRES = windres
STRIP   = strip
endif

PYTHON3 = python3

################################################################################
# Functions
################################################################################

## Remove the topmost directory from the path string
# $(1) Path string (e.g. dir_a/dir_b/dir_c/)
define remove_top_dir
$(if $(findstring /,$(1)),$(patsubst %/,%,$(dir $(patsubst %/,%,$(1)))),)
endef

## Generate list of sub-directory paths from directory path
# $(1) Path string (e.g. dir_a/dir_b/dir_c/)
define get_subdirs
$(if $(1),\
$(patsubst %/,%,$(1)) $(call get_subdirs,$(call remove_top_dir,$(1))),\
)
endef

## Make each directory from the list depend on its parent directory
define make_dirs_depend_on_their_parent
$(foreach DIR,$(1),$(eval \
$(DIR): | $(call remove_top_dir,$(DIR))))
endef

## Function used to convert paths to filenames to be used e.g. to generate
## object filenames for given source files.
# $(1) List of file paths to convert
define path_to_fname
$(subst ..,$(PARENT_DIR),$(1))
endef

## Function used to convert filenames back to path to original file. This
## function needs to be an inverse to 'path_to_fname' function.
# $(1) List of filenames to convert back to original file paths
define fname_to_path
$(subst $(PARENT_DIR),..,$(1))
endef

## Build list of object files from provided list of source files
# $(1) List of source (*.c, *.cpp, etc.) files
define make_obj_files
$(addsuffix .o,$(addprefix $(BUILDDIR)/,$(call path_to_fname,$(basename \
$(1)))))
endef

################################################################################
# Prepare auxiliary variables
################################################################################

# Object files
OBJ = $(call make_obj_files,$(SRC))

# List of directories containing object files
OBJDIRS = $(sort $(foreach DIR,$(sort $(dir $(OBJ) $(OUT))),$(call \
get_subdirs,$(DIR))))

# Dependencies
NO_DEP_OBJ=$(call make_obj_files,$(NO_DEP))
DEP = $(addsuffix .d,$(basename $(filter-out $(NO_DEP_OBJ),$(OBJ))))

# Append defines to C Pre-Processor flags
CPPFLAGS += $(addprefix -D,$(DEFINE))
# Append include direcories to C Pre-Processor flags
CPPFLAGS += $(addprefix -I,$(INCLUDE))

# Determine linker command
ifeq ($(findstring .cpp,$(suffix $(SRC))),)
    LINKER = $(CC)
else
    LINKER = $(CXX)
endif


################################################################################
# Rules
################################################################################

# Pull in dependency info (only if we are not cleaning)
ifeq ($(filter clean,$(MAKECMDGOALS)),)
    -include $(DEP)
endif

# Dependency files also depend on object directories
$(DEP) $(OBJ): | $(OBJDIRS)

# Make sure directory creation is ordered during multi-thread build
$(call make_dirs_depend_on_their_parent,$(OBJDIRS))
# Create object directories
$(OBJDIRS):
ifeq ($(BUILDENV),windows)
	$(MKDIR) $(subst /,\,$@)
else
	$(MKDIR) $@
endif

# Invoke appropriate command to link the project
$(OUT): $(OUT).objlst $(EXTDEP)
	$(LINKER) $(LDFLAGS) @$< -o $@ $(LDLIBS)

# Object list file
$(OUT).objlst: $(OBJ)
	$(file >$@,$^)

# Enable second expansion
.SECONDEXPANSION:

# C source files compilation and dependency files
$(BUILDDIR)/%.o: $$(call fname_to_path,%.c)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(BUILDDIR)/%.d: $$(call fname_to_path,%.c)
	@echo Generating dependency for $<
	@$(CC) -MM -MT $(@:.d=.o) $(CPPFLAGS) $(CFLAGS) $< -MF $@

# C++ (.cpp) source files compilation and dependency files
$(BUILDDIR)/%.o: $$(call fname_to_path,%.cpp)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

$(BUILDDIR)/%.d: $$(call fname_to_path,%.cpp)
	@echo Generating dependency for $<
	@$(CXX) -MM -MT $(@:.d=.o) $(CPPFLAGS) $(CXXFLAGS) $< -MF $@

# Windows resource (.rc) source file compilation and dependency file
$(BUILDDIR)/%.d: $$(call fname_to_path,%.rc)
	@echo Generating dependency for $<
	@$(CC) -MM -MT $(@:.d=.o) -x c-header $(CPPFLAGS) $< -MF $@

$(BUILDDIR)/%.o: $$(call fname_to_path,%.rc)
	$(WINDRES) $(CPPFLAGS) -DPATHSEP=$(subst \,\\,$(PATHSEP)) -i $< -o $@

