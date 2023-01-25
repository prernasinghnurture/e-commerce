package authandinventory

import (
	"database/sql"
	"fmt"
	db "go-work/database"
	"log"
)

type Validation struct {
	userId   sql.NullInt64
	userName sql.NullString
}
type User struct {
	id       int
	name     string
	password string
	address  string
	date     int
	month    int
	year     int
	userCart []Cart
}

var LogedInUser Validation
var AdminPassword = "prerna"

var Users = make(map[int]User)

func Signup() {
	fmt.Println("\nEnter the values\n \n1. Username \n \n2. Password\n\n3. Address\n \n4. Date of Birth\n")
	var name, add, Pass string
	var date, month, year int
	fmt.Scan(&name, &Pass, &add)
	fmt.Scan(&date, &month, &year)

	_, err := db.Db.Exec(`INSERT INTO Users (Username, Password, Address, Date, Month, Year) VALUES (?, ?, ?, ?, ?, ?)`, name, Pass, add, date, month, year)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("\n /*******  You are successfully registered!!!  ******/")
}

func Login() {
	fmt.Println("\nPlease enter your username and password\n")
	var username, Pass string
	fmt.Scan(&username)
	fmt.Scan(&Pass)

	rows, err := db.Db.Query(`Select Users.id,  Users.UserName from Users where UserName = ? and password = ?`, username, Pass)
	if err != nil {
		log.Fatal(err)
	}
	for rows.Next() {
		err = rows.Scan(&LogedInUser.userId, &LogedInUser.userName)
	}
	if LogedInUser.userId.Valid == false {
		fmt.Println("\n/******   You are not a registered user!!   ******/ \n/****** Get Yourself registered first!!   ******/")
		return
	} else {
		AfterLoginOptions()
	}
}

func ViewAllUsers() {
	rows, err := db.Db.Query(`SELECT * FROM users`)
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
	for _, element := range users {
		fmt.Println(element.id, element.name, element.address, element.date, element.month, element.year)
	}
}
