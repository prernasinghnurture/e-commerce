package authandinventory

import (
	"database/sql"
	"fmt"
	db "go-work/database"
	"log"
)

type Cart struct {
	uderId       int
	prodId       int
	prodName     string
	prodQuantity int
}

type Product struct {
	id       int
	name     string
	price    int
	quantity int
}

var Products = make(map[int]Product)

func AddProducts() {
	var pass string
	fmt.Println("You can only add products if you are an admin\nPlease enter admin password")
	fmt.Scan(&pass)
	if pass != AdminPassword {
		fmt.Println("\n/******   Your password is incorrect   ******/\n")
		return
	}

	var name string
	var price, quantity int
	fmt.Println("Enter the name of the product")
	fmt.Scan(&name)
	var newEntry bool = false
	var productName sql.NullString
	rows, err := db.Db.Query(`SELECT Products.Name FROM Products where Name = ?`, name)
	if err != nil {
		fmt.Errorf(err.Error())
	}
	for rows.Next() {
		err = rows.Scan(&productName)
	}
	if productName.Valid == true {
		newEntry = true
		fmt.Println("Enter the quantity of the product")
		fmt.Scan(&quantity)
		_, err = db.Db.Query(`UPDATE Products SET Quantity = Quantity+? where Name = ?`, quantity, name)
		if err != nil {
			log.Fatal(err)
		}
	}
	if !newEntry {
		fmt.Println("\nEnter The quantity and Price you want to add\n")
		fmt.Scan(&quantity)
		fmt.Scan(&price)
		_, err := db.Db.Exec(`INSERT INTO  Products(Name, Price, Quantity) VALUES (?, ?, ?)`, name, price, quantity)
		if err != nil {
			log.Fatal(err)
		}
	}
	fmt.Println("/******   Your products have been added successfully   ******/ß")

}

func CheckInventory() {
	fmt.Println("S.NO   NAME    QUANTITY    PRICE")
	rows, err := db.Db.Query(`Select Products.ProductId, Products.Name, Products.Price, Products.Quantity from Products`)
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
	for _, element := range Products {
		fmt.Println(element.id, element.name, element.quantity, element.price)
	}
	if LogedInUser.userId.Valid == true {
		var PRODUCT_ID, QUANTITY int
		fmt.Println("\nPlease enter the product id  and quantity you want to buy\n")
		fmt.Scan(&PRODUCT_ID)
		fmt.Scan(&QUANTITY)
		var isProductAndQuantityValidation bool = false
		for key, element := range Products {
			if key == PRODUCT_ID && element.quantity >= QUANTITY {
				isProductAndQuantityValidation = true
			}
		}

		if !isProductAndQuantityValidation {
			fmt.Print("/******   Either you have entered incorrect product id or we do not have enough stocks   ******/")
			return
		}
		var singleProduct = Products[PRODUCT_ID]
		var productName = singleProduct.name
		rows, err := db.Db.Query(`Insert into Cart (UserId, ProductId, Name, Quantity) Values (?, ?, ?, ?) on duplicate key Update Quantity = Quantity+?`, LogedInUser.userId, PRODUCT_ID, productName, QUANTITY, QUANTITY)
		if err != nil {
			log.Fatal(err)
		}
		for rows.Next() {

		}
		fmt.Println("\n/******   Your products has been successfully added to the cart   ******/\n")
	}
}
