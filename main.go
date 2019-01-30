// rcs_contract_mgr project main.go
package main

import (
	"dbutil/db"
	"fmt"
	"io/ioutil"
	"os"

	"text/template"
)

func main() {
	fmt.Println("Hello...")
	redBuf, _ := ioutil.ReadFile(".\\tmpl.tpl")
	dbo := db.New("root:123456@tcp(10.89.4.203:3306)/tba2_db", "tba_accounts", "Account", "account", "user_id", "account")
	colList, _ := dbo.GetList()
	fmt.Println(colList.Cols)
	t := template.Must(template.New("testing").Parse(string(redBuf)))

	wFile, err := os.Create("F:\\go-dev\\src\\tbactl\\service\\account\\Account.go")
	if err != nil {
		fmt.Println(err)
		return
	}
	t.Execute(wFile, colList)
}
