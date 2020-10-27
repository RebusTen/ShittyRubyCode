#!/usr/bin/ruby2.5
module Logo
	
	def LogoOut
		puts "                                        "
		puts "      ____ ____ ____ ____ ____ ____ ____" 
		puts "     /___//___//___//___//___//___//___/"
		puts "    __   ____          ___    __     __ "
		puts "   / /  / __/  __ __  / _ )  / /    / / "
		puts "  / /  _\\ \\   / // / / _  | / /__  / /  "
		puts " / /  /___/   \\_, / /____/ /____/ / /   "
		puts "/_/          /___/               /_/    "
		puts "  //| //| //| //| //| //| //| //|       "
		puts " |/|||/|||/|||/|||/|||/|||/|||/||       "
		puts "                                        "
	end

	def NameOut(crName)
		puts "\tMade by " + crName
	end

	def ProjOut(pName)
		puts "\t\t Project " + pName
	end

	def LogoFull(name, project)
		Line()
		LogoOut()
		Line()
		NameOut(name)
		ProjOut(project)
		Line()
	end

	def Line
		puts "________________________________________"
	end

end
