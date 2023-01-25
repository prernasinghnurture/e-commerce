package Database

import (
	"database/sql"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

var Db *sql.DB

func InitilizeDb() {
	var Err error
	Db, Err = sql.Open("mysql", "root:Nurture@123@tcp(127.0.0.1:3306)/ecommerce?parseTime=true")
	if Err != nil {
		panic(Err.Error())
	}
	fmt.Println("Success!")
}
