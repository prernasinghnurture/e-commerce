package main

import (
	"fmt"
	authandInv "go-work/authandinventory"
	db "go-work/database"
)

func options() int {
	fmt.Println("\n1. Signup")
	fmt.Println("\n2. Login")
	fmt.Println("\n3. Check Inventory")
	fmt.Println("\n4. Exit")
	fmt.Println("\n5. Add products as an admin")
	fmt.Println("\n6. View All Users")
	var option int
	fmt.Scan(&option)
	if option != 1 && option != 2 && option != 3 && option != 4 && option != 5 && option != 6 {
		fmt.Println("\n/******   Please chose one of the above options   ******/\n")
		a := options()
		return a
	}
	return option
}

func main() {
	db.InitilizeDb()
	chosen := 0
	for chosen != -10 {
		chosen = options()
		if chosen == 1 {
			authandInv.Signup()
		} else if chosen == 2 {
			authandInv.Login()
		} else if chosen == 3 {
			authandInv.CheckInventory()
		} else if chosen == 5 {
			authandInv.AddProducts()
		} else if chosen == 6 {
			authandInv.ViewAllUsers()
		} else {
			chosen = -10
		}
		if chosen == -10 {
			fmt.Println("\n/******   You have successfully exit   ******/\n")
		}
	}
}
