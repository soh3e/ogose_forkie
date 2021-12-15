import pwd, sys

user_arr = []
with open('authusers.txt') as my_file:
    for line in my_file:
        user_arr.append(line)
        
for i in range(len(user_arr)):
    user_arr[i] = pwd.getpwnam(user_arr)
    print((user_arr[i].pw_name + ": " + user_arr[i].pw_shell)
