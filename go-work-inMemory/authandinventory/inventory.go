package authandinventory

import (
	"fmt"
	db "go-work/database"
	"log"
)

type Cart struct {
	prod_id      int
	prodName     string
	prodQuantity int
}

type Product struct {
	name     string
	id       int
	price    int
	quantity int
}

var products = make(map[int]Product)

func AddProducts() {
	var pass string
	fmt.Println("You can only add prodcts if you are an admin\nPlease enter admin password")
	fmt.Scan(&pass)
	if pass != AdminPassword {
		fmt.Println("\n/******   Your password is incorrect   ******/\n")
		return
	} else {
		var Name string
		var Price, Quantity int
		fmt.Println("Enter the name of the product")
		fmt.Scan(&Name)
		var temp = 0
		for _, element := range products {
			if element.name == Name {
				fmt.Println("\nEnter The quantity you want to add to this product\n")
				fmt.Scan(&Quantity)
				//fmt.Println(Quantity)
				var cnt = element.quantity + Quantity
				product := Product{
					id:       element.id,
					name:     element.name,
					price:    element.price,
					quantity: cnt,
				}
				products[element.id] = product
				temp = 1
				break
			}
		}
		if temp == 0 {
			fmt.Println("\nEnter The quantity and Price you want to add\n")
			fmt.Scan(&Quantity)
			fmt.Scan(&Price)
			// ProdId = ProdId + 1
			// product := Product{
			// 	id:       ProdId,
			// 	name:     Name,
			// 	price:    Price,
			// 	quantity: Quantity,
			// }
			// products[ProdId] = product
			result, err := db.Db.Exec(`INSERT INTO  Products(Name, Price, Quantity) VALUES (?, ?, ?)`, Name, Price, Quantity)
			if err != nil {
				log.Fatal(err)
			}

			id, err := result.LastInsertId()
			fmt.Println(id)
		}
	}
	fmt.Println("/******   Your products have been added successfully   ******/ß")

}

func CheckInventory() {
	fmt.Println("S.NO   NAME    PRICE    QUANTITY")
	for key, element := range products {
		fmt.Println(key, element.name, element.price, element.quantity)
		fmt.Println("\n")
	}
	if Log == 1 {
		var PRODUCT_ID, QUANTITY int
		fmt.Println("\nPlease enter the product id  and quantity you want to buy\n")
		fmt.Scan(&PRODUCT_ID)
		fmt.Scan(&QUANTITY)
		var s = products[PRODUCT_ID]
		USER_CART := Users[LoggedUserId].userCart
		if products[PRODUCT_ID].quantity < QUANTITY {
			fmt.Println("/******   NOT ENOUGH STOCK   ******/\n")
			return
		} else {
			product := Product{
				id:       PRODUCT_ID,
				name:     s.name,
				price:    s.price,
				quantity: s.quantity - QUANTITY,
			}
			products[PRODUCT_ID] = product
			var temp = 0
			for _, element := range USER_CART {
				if element.prod_id == PRODUCT_ID {
					temp = 1
					element.prodQuantity = element.prodQuantity + QUANTITY
					break
				}
			}
			if temp == 0 {

				USER_CART = append(USER_CART, Cart{
					prod_id:      PRODUCT_ID,
					prodName:     s.name,
					prodQuantity: QUANTITY,
				})
			}
			Updated_user := Users[LoggedUserId]
			Updated_user.userCart = USER_CART
			Users[LoggedUserId] = Updated_user
		}
		fmt.Println("\n/******   Your products has been successfully added to the cart   ******/\n")
	}
}
