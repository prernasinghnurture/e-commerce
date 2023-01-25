package authandinventory

import (
	"fmt"
	db "go-work/database"
	"log"
)

func AfterLoginOptions() {
	if LogedInUser.userId.Valid == false {
		fmt.Println("\n/*******  You are not login!!  ******/\n")
		return
	}
	fmt.Println("\n1.Logout \n2.Check your cart\n3.Add Items")
	var optionChosen int
	fmt.Scan(&optionChosen)
	if optionChosen == 1 {
		LogedInUser.userId.Valid = false
		fmt.Println("\n/******   You are successfully logged out   ******/")
		return
	} else if optionChosen == 2 {
		rows, err := db.Db.Query(`Select Cart.ProductId, Cart.Name, Cart.Quantity from cart where UserId = ?`, LogedInUser.userId)
		if err != nil {
			log.Fatal(err)
		}
		var cart []Cart
		for rows.Next() {
			var v Cart
			err = rows.Scan(&v.prodId, &v.prodName, &v.prodQuantity)
			cart = append(cart, v)
		}
		rows, err = db.Db.Query(`Select Products.ProductId, Products.Name, Products.Price, Products.Quantity from Products`)
		if err != nil {
			log.Fatal(err)
		}
		for rows.Next() {
			var localProduct Product
			err = rows.Scan(&localProduct.id, &localProduct.name, &localProduct.price, &localProduct.quantity)
			if err != nil {
				log.Fatal(err)
			}
			Products[localProduct.id] = localProduct
		}
		for _, element := range cart {
			fmt.Println(element.prodId, element.prodName, element.prodQuantity, element.prodQuantity*Products[element.prodId].price)
		}
		fmt.Println("If you want to checkout press c")
		var checkout string
		fmt.Scan(&checkout)
		if checkout == "c" || checkout == "C" {
			rows, err = db.Db.Query(`Delete from Cart where UserId = ?`, LogedInUser.userId)
			fmt.Println("Your Cart is empty Now")
		}

	} else {
		CheckInventory()
	}
	if LogedInUser.userId.Valid == true {
		AfterLoginOptions()
	}
}
