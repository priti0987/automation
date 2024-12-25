#type of variable
# print(type(10))
# x= 10
# y= 20
# print(x+y)
#typecasting
# number1 = input("enter  first number:  ")
# print(int(number1) + 2)
#operators
# +,-,*,/,%
# print( 1 + 2)
# print( 1 - 2)
# print( 1 * 2)
# print( 9 / 3)
# print(10%6) #reminder of operation
# #raise to **
# print(2**3)
# print( 15 // 4) #only answer for division
x=5
y=9
# x+=10#x=x+10
#
# y-=2
# print(x)
# print(y)
# print(x==y)
# print(x<y)
# print(x>y)
# print(x!=y)

# print( 10 <20)
# print( 10>20)
# print( 10 > 20 and  50>100)
# print( 10 < 20 or  50>100)
# print(not 10 == 20)
# print(not True)
# print(not False)
# print(not 1 >22)

#type casting
# x=input("Enter 1 number")
# y = input("Enter 2nd number")
# print(int(x)+int(y))

# x = 10
# y = 10
# if x == y :
#     print("x and y are eqaul..!")
# elif x > y:
#     print("x is greater than y ..!")
# elif x<y :
#     print("x is not greater than y ..!")
# else:
#     print("Dont know ..!")

# x=0
# while x < 10:
#     print(x)
#     x+=1

# for x in range(1,100):
#     print(x)

# x=0
# while x < 10:
#     x += 1
#     if x == 5:
#         continue
#     print(x)

#list

mylist = [10,20,30,True,55,66,6.5]
# print(mylist)
# mylist[4]=False
# print(mylist)
# print(len(mylist))
# # for x in mylist:
#     # print(x)
# print(max(mylist))
# print(min(mylist))
# mylist.append("okok")
# print(mylist)
# mylist.insert(9,"pp")
# print(mylist)
# mylist.remove(30)
# print(mylist)
# mylist.pop(1)#index
# print(mylist)
# print(mylist.index(True))

# mylist.sort()
# print(sorted(mylist))
# y = (1,5,88,6)
# x=list(y)
#
# x[3]=22
# # x=tuple(x)
# print(x)
#we cannot change tuple
# #dic
# person = {"name":"priti","age":66,"gender":"F","occ":"Engg"}
# # print(person)
# # print(person["name"])
# person["fav"] = "music"
# person["goal"] = 10
# # print(person)
# print(person.items())
# print(person.keys())
# print(person.values())
# print(2 in mylist)
# print(mylist)
# print(2 not in mylist)
# # print(30 in mylist )
# #funcion
# def name():
#     print("priti")
#
# name()
# def add_(x = 2,w=3):
#     return(x+w)
#
#
# s=add_(53,6)
# # print(s)
# # print(add_())
#
# def my_sum(*numbers):
#     result = 0
#     for numb in numbers:
#         result += numb
#     return result
#
#
# print(my_sum(10,55,1))
# # print(my_sum(1,30))

#exceptional handling
# try:
#     x = int(input("first number = "))
#     y = int(input("second number = "))
#     print(x/y)
# except ValueError:
#     print("Invalid value")
# except ZeroDivisionError:
#     print("Enter number other than zero")
#     y=1
#     print(x/y)
# finally:
#     print("End of prog..!!")

#
# def priti():
#     if True:
#         # raise ValueError("KAY ZALLLEEE.......!!!!!!!!")
#         # raise OverflowError("..............")
#         # raise ZeroDivisionError("ijoijkjdfkds")
#         raise IndentationError("jsdhfjshiiii989879")
# # priti()
#
# # x=102
# # y=20
# # assert (x<y)
# file = open("C:\\pratap\\text123.txt",'w')
# file.write("priti........!!")
# # print(file.read())
# file.close()
#
# with open('C:\\pratap\\text123.txt','r') as f:
#     #jhhj
#     print(f.read())
#     pass
# from os import *
# #
# rename("C:\\pratap\\prata_textfile.txt","C:\\pratap\\pratapFuse.txt")
# # mkdir("c:\\priti_6nov2023")
# # chdir("c:\\priti_6nov2023")
# # mkdir("oll")

#strings
# text = "Priti \tBhavika \nPratap  \b ! "
# print("lenght .. " + str(len(text)))
# print(text[5:])
# for l in text:
#     print(l)
# print(text)
#both inputs are taking as string so printing with out type change
# name = input("Enter name ")
# age = (input("Enter age "))
#
# # print("My name is " + name + " and My age is " + age )
# print("My name is {} and My age is {}".format(name ,age))
# print(name.lower())
# print(name.upper())
# print(name.title())
# print(name.swapcase())

# text = "priti bhavika Pratap"
# print(text.count("a"))
# print(text.find("p"))

# sep = ','
# mylist =['priti','bhavika','tiya']
# print(sep.join(mylist))
# opp = "priti bhavika tiya pratap"
# dd = opp.split("a")
# print(dd)
# print(opp.replace("p","ll"))
x="hello"[0]
print(x)