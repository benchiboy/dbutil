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
	dbo := db.New("root:123456@tcp(10.89.4.203:3306)/tba2_db", "tba_account_post_positions", "PostPosition", "post_positions", "post_no")
	colList, _ := dbo.GetList()
	fmt.Println(colList.Cols)
	t := template.Must(template.New("testing").Parse(string(redBuf)))
	t.Execute(os.Stdout, colList)
}
