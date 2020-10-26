#!/usr/bin/ruby

require 'cli/ui'
require 'csv'

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
def FindExistInCols(data, target,fCase = 0)
	ind = -1
	temp = -1
	for i in data do
		for j in i do
			temp = j.index(target)
			if !temp.nil? then
				if fCase == 0 then
					ind = data.index(i)
				end
				if fCase == 1 then
					ind = i.index(j)
				end
				break
			end
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
data = ReadUsersFile()
while choiceS == "Add..." || choiceA == "Add..." do
	choiceS = GetServer(data)
	if choiceS == "Add..." then
		temp = choiceS
		while temp == "Add..." do
			print("Enter new server:")
			temp = gets.chomp
			if temp == choiceS || FindExistInCols(data, temp) != -1 then
				puts("Error, please try again!")
				temp = "Add..."
				next
			end
			data.append([temp])
			AddInfo(data)
		end
	end
	choiceA = ChooseAccount(data,FindExistInCols(data,choiceS))
	if choiceA == "Add..." then
		temp = choiceA
		while temp == "Add..." do
			print("Enter new user:")
			temp = gets.chomp
			if temp == choiceA || FindExistInCols(data, temp) != -1 then
				puts("Error, please try again!")
				temp = "Add..."
				next
			end
			data[FindExistInCols(data, choiceS)].append(temp)
			AddInfo(data)
		end
	end
end	
