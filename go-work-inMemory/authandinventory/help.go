package authandinventory

import (
	"fmt"
)

func AfterLoginOptions() {
	if Log == 0 {
		fmt.Println("\n/*******  You are not login!!  ******/\n")
		return
	}
	fmt.Println("\n1.Logout \n2.Check your cart\n3.Add Items")
	var option_chosen int
	fmt.Scan(&option_chosen)
	if option_chosen == 1 {
		fmt.Println("\n/******   You are successfully logged out   ******/")
		Log = 0
		return
	} else if option_chosen == 2 {
		var logged_user_cart = Users[LoggedUserId].userCart
		for _, element := range logged_user_cart {
			fmt.Println("ID Name   Quantity   Price   Total")
			fmt.Println(element.prod_id, element.prodName, element.prodQuantity, products[element.prod_id].price, products[element.prod_id].price*element.prodQuantity)
		}
	} else {
		CheckInventory()
	}
	if Log != 0 {
		AfterLoginOptions()
	}
}
