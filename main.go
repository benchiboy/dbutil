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
	//	fmt.Println("Hello...")
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

	//	fmt.Println("Hello...")
	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "b_flow_point", "Flow_point", "flow_point", "id", "flow_point")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/flow_point/Flow_Point.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

	//	fmt.Println("Hello...")
	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "b_service_point", "Service_Point", "service_point", "id", "service_point")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/service_point/Service_Point.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

	//	fmt.Println("Hello...")
	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "b_flow_point_fields", "FlowPointFields", "flowpointfields", "id", "flow_point_fields")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/flow_point_fields/Flow_Point_Fields.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

	//	fmt.Println("Hello...")
	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "b_service_fields", "ServiceFields", "servicefields", "id", "service_fields")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/service_fields/Service_Fields.go")
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

	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "b_flow", "Flow", "flow", "id", "flow")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/flow/Flow.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "b_user", "UserR", "user", "user_id", "user")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/user/User.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "t_provinces", "Provinces", "provinces", "id", "provinces")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/provinces/Provinces.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "t_health_code_define", "HealthCodeDefine", "HealthCodeDefine", "id", "health_code_define")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/health_code_define/Health_Code_Define.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

	//	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	//	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "b_user_personal", "UserPersonal", "userpersonal", "user_id", "user_personal")
	//	colList, _ := dbo.GetList()
	//	fmt.Println(colList.Cols)
	//	t := template.Must(template.New("testing").Parse(string(redBuf)))

	//	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/user_personal/User_Personal.go")
	//	if err != nil {
	//		fmt.Println(err)
	//		return
	//	}
	//	t.Execute(wFile, colList)

	redBuf, _ := ioutil.ReadFile("./tmpl.tpl")
	dbo := db.New("root:123456@tcp(127.0.0.1:3306)/hcd_db", "b_personal_log", "PersonalLog", "personal_log", "log_id", "personal_log")
	colList, _ := dbo.GetList()
	fmt.Println(colList.Cols)
	t := template.Must(template.New("testing").Parse(string(redBuf)))

	wFile, err := os.Create("/Users/zhoutuguang/go/src/hcd-gate/service/personal_log/Personal_Log.go")
	if err != nil {
		fmt.Println(err)
		return
	}
	t.Execute(wFile, colList)

}
