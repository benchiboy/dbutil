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
	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "b_flow_point_role", "Flow_point_role", "flow_point_role", "id", "flow_point_role")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/flow_point_role/Flow_Point_Role.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "b_clinic", "Clinic", "clinic", "clinic_id", "clinic")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/clinic/Clinic.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "f_user_data", "UserData", "userdata", "flow_batch_id", "user_data")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/user_data/User_Data.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "b_role", "Role", "role", "role_index", "role")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/role/Role.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "b_personal", "Personal", "personal", "personnel_id", "personal")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/personal/Personal.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

}
