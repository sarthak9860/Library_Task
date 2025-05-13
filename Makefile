DEBUG=0
EXECUTABLE_NAME=exe

CC=gcc
CFLAGS= -Wall
LDFLAGS=

MYLIB=mylib

ifeq ($(DEBUG),1)
    CFLAGS += -g -O0
else
    CFLAGS = -c -O3
endif

COMPILER_CALL= $(CC) $(CFLAGS)

# Define the object files needed for the static library
LIB_OBJS = hello.o here.o bye.o

# Define the object files needed for the executable
EXEC_OBJS = main.o

# The target to build everything
target: dynamic_build dynamic_link execute 

# Rule to compile .c files into .o files
%.o: %.c
	$(CC) -c -fPIC $< -o $@

# Rule to create the static library
static_build: $(LIB_OBJS)
	ar rs $(MYLIB).a $(LIB_OBJS)

# Rule to link the executable
static_link: $(EXEC_OBJS) $(MYLIB).a
	$(CC) $(EXEC_OBJS) -o $(EXECUTABLE_NAME) -L. -l:$(MYLIB).a

# Rule to build dynamic lib
dynamic_build: $(LIB_OBJS)
	$(CC) $(LIB_OBJS) -shared -o $(MYLIB).so
	
dynamic_link: $(EXEC_OBJS) $(MYLIB).so
	$(CC) $(EXEC_OBJS) -o $(EXECUTABLE_NAME) -L. -l:$(MYLIB).so
	export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH

# Rule to execute the program
execute:
	./$(EXECUTABLE_NAME)

# Clean up generated files
#clean:
#   rm -f $(LIB_OBJS) $(EXEC_OBJS) $(EXECUTABLE_NAME) $(MYLIB).a
