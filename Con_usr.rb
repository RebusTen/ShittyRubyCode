#!/usr/bin/ruby

require 'Logo.rb'
require 'cli/ui'
require 'csv'
include Logo

def ReadUsersFile()
	data = []
	num = 0
	CSV.foreach('userinf.csv') do |record|
		data << record
		num+=1
	end
	return data
end
def GetServer(serveruser)
	num = serveruser.length()
	i = 0
	choice = CLI::UI::Prompt.ask('What server would you like to choose?') do |handler| 
		while i < num do
			handler.option(serveruser[i][0]) { |selection| selection }
			i+=1
		end
		handler.option("Add...") { |selection| selection }
	end
	return choice
end
def AddInfo(data)
	CSV.open('userinf.csv','w') do |csv|
		data.each {|record| csv << record}
	end
end
def FindExistRow(data, target)
	ind = -1
	for i in data do
		if i[0]==target then
			ind = data.index(i)
		end
	end	
	return ind
end
def FindExistEl(data, target,row)
	ind = -1
	for i in data[row] do
		if i == target && data[row].index(i) != 0 then
			ind = data[row].index(target)
		end
	end
	return ind
end
def ChooseAccount(data, server)
	num = data[server].length()
	i = 1
	choice = CLI::UI::Prompt.ask('What server would you like to choose?') do |handler| 
		while i < num do
			handler.option(data[server][i]) { |selection| selection }
			i+=1
		end
		handler.option("Add...") { |selection| selection }
	end
	return choice
end

choiceS = "Add..."
choiceA = "Add..."
Logo.LogoFull("PoisonousJAM","ConUsr")
data = ReadUsersFile()
while choiceS == "Add..." || choiceA == "Add..." do
	choiceS = GetServer(data)
	if choiceS == "Add..." then
		temp = choiceS
		while temp == "Add..." do
			print("Enter new server:")
			temp = gets.chomp
			if temp == choiceS || FindExistRow(data, temp) != -1 then
				puts("Error, please try again!")
				temp = "Add..."
				next
			end
			data.append([temp])
			AddInfo(data)
		end
	end
	choiceA = ChooseAccount(data,FindExistRow(data,choiceS))
	if choiceA == "Add..." then
		temp = choiceA
		while temp == "Add..." do
			print("Enter new user:")
			temp = gets.chomp
			if temp == choiceA || FindExistEl(data,temp,FindExistRow(data,choiceS)) != -1 then
				puts("Error, please try again!")
				temp = "Add..."
				next
			end
			data[FindExistRow(data, choiceS)].append(temp)
			AddInfo(data)
			choiceA = temp
		end
		choiceA = "Add..."
	end
	#system("ssh " + choiceA + "@" + choiceS)
end	
