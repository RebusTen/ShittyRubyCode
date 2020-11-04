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
def GetServer(serveruser, removing = false)
	num = serveruser.length()
	i = 0
	choice = CLI::UI::Prompt.ask('What server would you like to choose?') do |handler| 
		while i < num do
			handler.option(serveruser[i][0]) { |selection| selection }
			i+=1
		end
		if !removing then
			handler.option("Add...") { |selection| selection }
			handler.option("Remove...") { |selection| selection }
		end
		handler.option("Exit...") { |selection| selection }
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
def ChooseAccount(data, server, removing = false)
	num = data[server].length()
	i = 1
	choice = CLI::UI::Prompt.ask('What user would you like to choose?') do |handler| 
		while i < num do
			handler.option(data[server][i]) { |selection| selection }
			i+=1
		end
		if !removing then
			handler.option("Add...") { |selection| selection }
			handler.option("Remove...") { |selection| selection }
		end
		handler.option("Back...") { |selection| selection }
	end
	return choice
end
def YNQuestion(question = "Are you sure?")
	choice = CLI::UI::Prompt.ask(question) do |handler| 
		handler.option("Yes") { |selection| selection }
		handler.option("No") { |selection| selection }
	end
	if choice == "Yes" then
		return true
	else
		return false
	end
end
system("touch userinf.csv")
choiceS = "Add..."
choiceA = "Add..."
servChosen = false
removingAcc = false
Logo.LogoFull("PoisonousJAM","ConUsr")
data = ReadUsersFile()
while choiceS == "Add..." || choiceA == "Add..." || choiceA == "Back..." || choiceA == "Remove..." do
	if !servChosen then
		choiceS = GetServer(data)
	end
	servChosen = false
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
			if YNQuestion("Do you want to add " + temp + " to list of servers ?") then
				data.append([temp])
				AddInfo(data)
				choiceS = temp
			end
		end
	end
	if choiceS == "Exit..." then
		break
	end
	if choiceS == "Remove..." then
		temp = GetServer(data,true)
		if temp == "Exit..." then
			choiceS = "Add..."
			next
		end
		if YNQuestion("Are you sure you want to remove " + temp + " server from the list") then
			data.delete_at(FindExistRow(data, temp))
			AddInfo(data)
			choiceS = "Add..."
			next
		end
	end
	
	if !removingAcc then
		choiceA = ChooseAccount(data, FindExistRow(data, choiceS))
	end
	if choiceA == "Add..." then
		temp = choiceA
		while temp == "Add..." do
			print("Enter new user:")
			temp = gets.chomp
			if temp == choiceA || temp == "Back..." || FindExistEl(data,temp,FindExistRow(data,choiceS)) != -1 then
				puts("Error, please try again!")
				temp = "Add..."
				next
			end
			if YNQuestion("Do you want to add " + temp + " to list of " + choiceS + " users ?") then
				data[FindExistRow(data, choiceS)].append(temp)
				AddInfo(data)
				choiceA = temp
			end
		end
		choiceA = "Add..."
		next
	end
	if choiceA == "Remove..." then
		removingAcc = true
		temp = ChooseAccount(data, FindExistRow(data,choiceS), true)
		if temp == "Back..." then
			removingAcc = false
			servChosen = true
			choiceA = "Add..."
			next
		end
		if YNQuestion("Are you sure you want to remove " + temp + " from " + choiceS + " list ?") then
			data[FindExistRow(data,choiceS)].delete_at(FindExistEl(data,temp,FindExistRow(data,choiceS)))
			AddInfo(data)
			servChosen = true
			next
		end
	end

	if choiceA == "Back..." then
		next
	end
	if YNQuestion("Do you want to connect to " + choiceS + " as " + choiceA + " ?") then
		system("ssh " + choiceA + "@" + choiceS)
	else
		choiceA = "Back..."
	end
end	
