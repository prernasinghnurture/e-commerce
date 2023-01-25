package authandinventory

import (
	"fmt"
	db "go-work/database"
	"log"
)

type User struct {
	name     string
	password string
	id       int
	address  string
	date     int
	month    int
	year     int
	userCart []Cart
}

var CustomerId = 0
var ProdId = 0
var AdminPassword = "prerna"

var Log = 0
var LoggedUserId = -1
var Users = make(map[int]User)

func Signup() {
	fmt.Println("\nEnter the values\n \n1. Username \n \n2. Password\n\n3. Address\n \n4. Date of Birth\n")
	var name, add, Pass string
	var date, month, year int
	fmt.Scan(&name, &Pass, &add)
	fmt.Scan(&date, &month, &year)
	// var cart []Cart
	// CustomerId = CustomerId + 1
	// user := User{
	// 	name:     name,
	// 	password: Pass,
	// 	id:       CustomerId,
	// 	address:  add,
	// 	date:     date,
	// 	month:    month,
	// 	year:     year,
	// 	userCart: cart,
	// }
	//Users[CustomerId] = user

	result, err := db.Db.Exec(`INSERT INTO Users (Username, Password, Address, Date, Month, Year) VALUES (?, ?, ?, ?, ?, ?)`, name, Pass, add, date, month, year)
	if err != nil {
		log.Fatal(err)
	}

	id, err := result.LastInsertId()
	fmt.Println(id)
	fmt.Println("\n /*******  You are successfully registered!!!  ******/")
}

func Login() {
	fmt.Println("\nPlease enter your username and password\n")
	var username, Pass string
	fmt.Scan(&username)
	fmt.Scan(&Pass)
	for _, element := range Users {
		if element.name == username && element.password == Pass {
			Log = 1
			LoggedUserId = element.id
			break
		}
	}
	if Log == 0 {
		fmt.Println("\n/******   You are not a registered user!!   ******/ \n/****** Get Yourself registered first!!   ******/")
		return
	} else {
		AfterLoginOptions()
	}
}

func ViewAllUsers() {
	rows, err := db.Db.Query(`SELECT * FROM users`) // check err
	defer rows.Close()
	if err != nil {
		log.Fatal(err)
	}
	var users []User
	for rows.Next() {
		var u User
		err = rows.Scan(&u.id, &u.name, &u.password, &u.address, &u.date, &u.month, &u.year) // check err
		users = append(users, u)
	}
	err = rows.Err() // check err
}
