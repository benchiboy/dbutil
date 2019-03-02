package {{.PackageName}}

import (
	"database/sql"
	"fmt"
	"log"
	"strings"
	"time"

	_ "github.com/jinzhu/gorm/dialects/mysql"
)

const (
	SQL_NEWDB	= "NewDB  ===>"
	SQL_INSERT  = "Insert ===>"
	SQL_UPDATE  = "Update ===>"
	SQL_SELECT  = "Select ===>"
	SQL_DELETE  = "Delete ===>"
	SQL_ELAPSED = "Elapsed===>"
	SQL_ERROR   = "Error  ===>"
	SQL_TITLE   = "===================================="
	DEBUG       = 1
	INFO        = 2
)

type Search struct {
	{{range .Cols}}
	{{.ColName}}	{{.ColType}}	`json:"{{.ColTagName}}"`{{end}}
	PageNo   int    `json:"page_no"`
	PageSize int    `json:"page_size"`
	SortFld  string `json:"sort_fld"`
}

type {{.EntityName}}List struct {
	DB      *sql.DB
	Level   int
	Total   int      `json:"total"`
	{{.EntityName}}s []{{.EntityName}} `json:"{{.EntityName}}"`
}

type {{.EntityName}} struct {
	{{range .Cols}}
	{{.ColName}}	{{.ColType}}	`json:"{{.ColTagName}}"`{{end}}
}


type Form struct {
	Form   {{.EntityName}} `json:"{{.EntityName}}"`
}

/*
	说明：创建实例对象
	入参：db:数据库sql.DB, 数据库已经连接, level:日志级别
	出参：实例对象
*/

func New(db *sql.DB, level int) *{{.EntityName}}List {
	if db==nil{
		log.Println(SQL_SELECT,"Database is nil")
		return nil
	}
	return &{{.EntityName}}List{DB: db, Total: 0, {{.EntityName}}s: make([]{{.EntityName}}, 0), Level: level}
}

/*
	说明：创建实例对象
	入参：url:连接数据的url, 数据库还没有CONNECTED, level:日志级别
	出参：实例对象
*/

func NewUrl(url string, level int) *{{.EntityName}}List {
	var err error
	db, err := sql.Open("mysql", url)
	if err != nil {
		log.Println(SQL_SELECT,"Open database error:", err)
		return nil
	}
	if err = db.Ping(); err != nil {
		log.Println(SQL_SELECT,"Ping database error:", err)
		return nil
	}
	return &{{.EntityName}}List{DB: db, Total: 0, {{.EntityName}}s: make([]{{.EntityName}}, 0), Level: level}
}

/*
	说明：得到符合条件的总条数
	入参：s: 查询条件
	出参：参数1：返回符合条件的总条件, 参数2：如果错误返回错误对象
*/

func (r *{{.EntityName}}List) GetTotal(s Search) (int, error) {
	var where string
	l := time.Now()
	{{range .Cols}}
	{{if or (eq .ColType "int64")  (eq .ColType "int")}}
	if s.{{.ColName}} != 0 {
		where += " and {{.ColTagName}}=" + fmt.Sprintf("%d", s.{{.ColName}})
	}	{{end}}	{{if eq .ColType "float64" }}
	if s.{{.ColName}} != 0 {
		where += " and {{.ColTagName}}=" + fmt.Sprintf("%f", s.{{.ColName}})
	}	{{end}}	{{if eq .ColType "string" }}
	if s.{{.ColName}} != "" {
		where += " and {{.ColTagName}}='" + s.{{.ColName}} + "'"
	}	{{end}}
	{{end}}
	qrySql := fmt.Sprintf("Select count(1) as total from {{.TableName}}   where 1=1 %s", where)
	if r.Level == DEBUG {
		log.Println(SQL_SELECT, qrySql)
	}
	rows, err := r.DB.Query(qrySql)
	if err != nil {
		log.Println(SQL_ERROR, err.Error())
		return 0, err
	}
	defer rows.Close()
	var total int
	for rows.Next() {
		rows.Scan(&total)
	}
	if r.Level == DEBUG {
		log.Println(SQL_ELAPSED, time.Since(l))
	}
	return total, nil
}

/*
	说明：根据主键查询符合条件的条数
	入参：s: 查询条件
	出参：参数1：返回符合条件的对象, 参数2：如果错误返回错误对象
*/

func (r {{.EntityName}}List) Get(s Search) (*{{.EntityName}}, error) {
	var where string
	l := time.Now()
	{{range .Cols}}
	{{if or (eq .ColType "int64")  (eq .ColType "int")}}
	if s.{{.ColName}} != 0 {
		where += " and {{.ColTagName}}=" + fmt.Sprintf("%d", s.{{.ColName}})
	}	{{end}}	{{if eq .ColType "float64" }}
	if s.{{.ColName}} != 0 {
		where += " and {{.ColTagName}}=" + fmt.Sprintf("%f", s.{{.ColName}})
	}	{{end}}	{{if eq .ColType "string" }}
	if s.{{.ColName}} != "" {
		where += " and {{.ColTagName}}='" + s.{{.ColName}} + "'"
	}	{{end}}
	{{end}}
	
	qrySql := fmt.Sprintf("Select {{range .Cols}}{{if eq .ColTagName "version"}}{{.ColTagName}}{{else}}{{.ColTagName}},{{end}}{{end}} from {{.TableName}} where 1=1 %s ", where)
	if r.Level == DEBUG {
		log.Println(SQL_SELECT, qrySql)
	}
	rows, err := r.DB.Query(qrySql)
	if err != nil {
		log.Println(SQL_ERROR, err.Error())
		return nil, err
	}
	defer rows.Close()

	var p  {{.EntityName}}
	if !rows.Next() {
		return nil, fmt.Errorf("Not Finded Record")
	} else {
		rows.Scan({{range .ColInserts}}&p.{{if eq .ColTagName "version"}}{{.ColName}}{{else}}{{.ColName}},{{end}}{{end}})
	}
	log.Println(SQL_ELAPSED, r)
	if r.Level == DEBUG {
		log.Println(SQL_ELAPSED, time.Since(l))
	}
	return &p, nil
}

/*
	说明：根据条件查询复核条件对象列表，支持分页查询
	入参：s: 查询条件
	出参：参数1：返回符合条件的对象列表, 参数2：如果错误返回错误对象
*/

func (r *{{.EntityName}}List) GetList(s Search) ([]{{.EntityName}}, error) {
	var where string
	l := time.Now()
	
	{{range .Cols}}
	{{if or (eq .ColType "int64")  (eq .ColType "int") }}
	if s.{{.ColName}} != 0 {
		where += " and {{.ColTagName}}=" + fmt.Sprintf("%d", s.{{.ColName}})
	}	{{end}}	{{if eq .ColType "float64" }}
	if s.{{.ColName}} != 0 {
		where += " and {{.ColTagName}}=" + fmt.Sprintf("%f", s.{{.ColName}})
	}	{{end}}	{{if eq .ColType "string" }}
	if s.{{.ColName}} != "" {
		where += " and {{.ColTagName}}='" + s.{{.ColName}} + "'"
	}	{{end}}
	{{end}}
	
	var qrySql string
	if s.PageSize==0 &&s.PageNo==0{
		qrySql = fmt.Sprintf("Select {{range .Cols}}{{if eq .ColTagName "version"}}{{.ColTagName}}{{else}}{{.ColTagName}},{{end}}{{end}} from {{.TableName}} where 1=1 %s", where)
	}else{
		qrySql = fmt.Sprintf("Select {{range .Cols}}{{if eq .ColTagName "version"}}{{.ColTagName}}{{else}}{{.ColTagName}},{{end}}{{end}} from {{.TableName}} where 1=1 %s Limit %d offset %d", where, s.PageSize, (s.PageNo-1)*s.PageSize)
	}
	if r.Level == DEBUG {
		log.Println(SQL_SELECT, qrySql)
	}
	rows, err := r.DB.Query(qrySql)
	if err != nil {
		log.Println(SQL_ERROR, err.Error())
		return nil, err
	}
	defer rows.Close()

	var p {{.EntityName}}
	for rows.Next() {
		rows.Scan({{range .Cols}}&p.{{if eq .ColTagName "version"}}{{.ColName}}{{else}}{{.ColName}},{{end}}{{end}})
		r.{{.EntityName}}s = append(r.{{.EntityName}}s, p)
	}
	log.Println(SQL_ELAPSED, r)
	if r.Level == DEBUG {
		log.Println(SQL_ELAPSED, time.Since(l))
	}
	return r.{{.EntityName}}s, nil
}

/*
	说明：根据条件查询复核条件对象列表，支持分页查询
	入参：s: 查询条件
	出参：参数1：返回符合条件的对象列表, 参数2：如果错误返回错误对象
*/

func (r *{{.EntityName}}List) GetListExt(s Search, fList []string) ([][]common.Data, error) {
	var where string
	l := time.Now()
	
	{{range .Cols}}
	{{if or (eq .ColType "int64")  (eq .ColType "int")}}
	if s.{{.ColName}} != 0 {
		where += " and {{.ColTagName}}=" + fmt.Sprintf("%d", s.{{.ColName}})
	}	{{end}}	{{if eq .ColType "float64" }}
	if s.{{.ColName}} != 0 {
		where += " and {{.ColTagName}}=" + fmt.Sprintf("%f", s.{{.ColName}})
	}	{{end}}	{{if eq .ColType "string" }}
	if s.{{.ColName}} != "" {
		where += " and {{.ColTagName}}='" + s.{{.ColName}} + "'"
	}	{{end}}
	{{end}}
	

	colNames := ""
	for _, v := range fList {
		colNames += v + ","

	}
	colNames = strings.TrimRight(colNames, ",")

	var qrySql string
	if s.PageSize==0 &&s.PageNo==0{
		qrySql = fmt.Sprintf("Select %s from {{.TableName}} where 1=1 %s", colNames,where)
	}else{
		qrySql = fmt.Sprintf("Select %s from {{.TableName}} where 1=1 %s Limit %d offset %d", colNames,where, s.PageSize, (s.PageNo-1)*s.PageSize)
	}
	if r.Level == DEBUG {
		log.Println(SQL_SELECT, qrySql)
	}
	rows, err := r.DB.Query(qrySql)
	if err != nil {
		log.Println(SQL_ERROR, err.Error())
		return nil, err
	}
	defer rows.Close()

	Columns, _ := rows.Columns()
	values := make([]sql.RawBytes, len(Columns))
	scanArgs := make([]interface{}, len(values))
	for i := range values {
		scanArgs[i] = &values[i]
	}

	rowData := make([][]common.Data, 0)
	for rows.Next() {
		err = rows.Scan(scanArgs...)
		colData := make([]common.Data, 0)
		for k, _ := range values {
			d := new(common.Data)
			d.FieldName = Columns[k]
			d.FieldValue = string(values[k])
			colData = append(colData, *d)
		}
		rowData = append(rowData, colData)
	}

	log.Println(SQL_ELAPSED, "==========>>>>>>>>>>>", rowData)
	if r.Level == DEBUG {
		log.Println(SQL_ELAPSED, time.Since(l))
	}
	return rowData, nil
}




/*
	说明：根据主键查询符合条件的记录，并保持成MAP
	入参：s: 查询条件
	出参：参数1：返回符合条件的对象, 参数2：如果错误返回错误对象
*/

func (r *{{.EntityName}}List) GetExt(s Search) (map[string]string, error) {
	var where string
	l := time.Now()

	{{range .Cols}}
	{{if or (eq .ColType "int64")  (eq .ColType "int")}}
	if s.{{.ColName}} != 0 {
		where += " and {{.ColTagName}}=" + fmt.Sprintf("%d", s.{{.ColName}})
	}	{{end}}	{{if eq .ColType "float64" }}
	if s.{{.ColName}} != 0 {
		where += " and {{.ColTagName}}=" + fmt.Sprintf("%f", s.{{.ColName}})
	}	{{end}}	{{if eq .ColType "string" }}
	if s.{{.ColName}} != "" {
		where += " and {{.ColTagName}}='" + s.{{.ColName}} + "'"
	}	{{end}}
	{{end}}

	qrySql := fmt.Sprintf("Select {{range .Cols}}{{if eq .ColTagName "version"}}{{.ColTagName}}{{else}}{{.ColTagName}},{{end}}{{end}} from {{.TableName}} where 1=1 %s ", where)
	if r.Level == DEBUG {
		log.Println(SQL_SELECT, qrySql)
	}
	rows, err := r.DB.Query(qrySql)
	if err != nil {
		log.Println(SQL_ERROR, err.Error())
		return nil, err
	}
	defer rows.Close()


	Columns, _ := rows.Columns()

	values := make([]sql.RawBytes, len(Columns))
	scanArgs := make([]interface{}, len(values))
	for i := range values {
		scanArgs[i] = &values[i]
	}

	if !rows.Next() {
		return nil, fmt.Errorf("Not Finded Record")
	} else {
		err = rows.Scan(scanArgs...)
	}

	fldValMap := make(map[string]string)
	for k, v := range Columns {
		fldValMap[v] = string(values[k])
	}

	log.Println(SQL_ELAPSED, "==========>>>>>>>>>>>", fldValMap)
	if r.Level == DEBUG {
		log.Println(SQL_ELAPSED, time.Since(l))
	}
	return fldValMap, nil

}

/*
	说明：插入对象到数据表中，这个方法要求对象的各个属性必须赋值
	入参：p:插入的对象
	出参：参数1：如果出错，返回错误对象；成功返回nil
*/

func (r {{.EntityName}}List) Insert(p {{.EntityName}}) error {
	l := time.Now()
	exeSql := fmt.Sprintf("Insert into  {{.TableName}}({{range .ColInserts}}{{if eq .ColTagName "version"}}{{.ColTagName}}{{else}}{{.ColTagName}},{{end}}{{end}})  values({{range .Cols}}{{if eq .ColTagName "version"}}?{{else}}?,{{end}}{{end}})")
	if r.Level == DEBUG {
		log.Println(SQL_INSERT, exeSql)
	}
	_, err := r.DB.Exec(exeSql, {{range .ColInserts}}{{if eq .ColTagName "version"}}p.{{.ColName}}{{else}}p.{{.ColName}},{{end}}{{end}})
	if err != nil {
		log.Println(SQL_ERROR, err.Error())
		return err
	}
	if r.Level == DEBUG {
		log.Println(SQL_ELAPSED, time.Since(l))
	}
	return nil
}


/*
	说明：插入对象到数据表中，这个方法会判读对象的各个属性，如果属性不为空，才加入插入列中；
	入参：p:插入的对象
	出参：参数1：如果出错，返回错误对象；成功返回nil
*/


func (r {{.EntityName}}List) InsertEntity(p {{.EntityName}}) error {
	l := time.Now()
	var colNames, colTags string
	valSlice := make([]interface{}, 0)
	{{range .ColInserts}}
	{{if or (eq .ColType "int64")  (eq .ColType "int")}}
	if p.{{.ColName}} != 0 {
		colNames += "{{.ColTagName}},"
		colTags += "?,"
		valSlice = append(valSlice, p.{{.ColName}})
	}	{{end}}	{{if eq .ColType "string" }}
	if p.{{.ColName}} != "" {
		colNames += "{{.ColTagName}},"
		colTags += "?,"
		valSlice = append(valSlice, p.{{.ColName}})
	}	{{end}}	{{if eq .ColType "float64" }}
	if p.{{.ColName}} != 0.00 {
		colNames += "{{.ColTagName}},"
		colTags += "?,"
		valSlice = append(valSlice, p.{{.ColName}})
	}	{{end}}	{{end}}
	
	colNames = strings.TrimRight(colNames, ",")
	colTags = strings.TrimRight(colTags, ",")
	exeSql := fmt.Sprintf("Insert into  {{.TableName}}(%s)  values(%s)", colNames, colTags)
	if r.Level == DEBUG {
		log.Println(SQL_INSERT, exeSql)
	}
	stmt, err := r.DB.Prepare(exeSql)
	if err != nil {
		log.Println(SQL_ERROR, err.Error())
		return err
	}
	defer stmt.Close()

	ret, err := stmt.Exec(valSlice...)
	if err != nil {
		log.Println(SQL_INSERT, "Insert data error: %v\n", err)
		return err
	}
	if LastInsertId, err := ret.LastInsertId(); nil == err {
		log.Println(SQL_INSERT, "LastInsertId:", LastInsertId)
	}
	if RowsAffected, err := ret.RowsAffected(); nil == err {
		log.Println(SQL_INSERT, "RowsAffected:", RowsAffected)
	}

	if r.Level == DEBUG {
		log.Println(SQL_ELAPSED, time.Since(l))
	}
	return nil
}

/*
	说明：插入一个MAP到数据表中；
	入参：m:插入的Map
	出参：参数1：如果出错，返回错误对象；成功返回nil
*/

func (r {{.EntityName}}List) InsertMap(m map[string]interface{}) error {
	l := time.Now()
	var colNames, colTags string
	valSlice := make([]interface{}, 0)
	for k, v := range m {
		colNames += k + ","
		colTags += "?,"
		valSlice = append(valSlice, v)
	}
	colNames = strings.TrimRight(colNames, ",")
	colTags = strings.TrimRight(colTags, ",")

	exeSql := fmt.Sprintf("Insert into  {{.TableName}}(%s)  values(%s)", colNames, colTags)
	if r.Level == DEBUG {
		log.Println(SQL_INSERT, exeSql)
	}
	stmt, err := r.DB.Prepare(exeSql)
	if err != nil {
		log.Println(SQL_ERROR, err.Error())
		return err
	}
	defer stmt.Close()

	ret, err := stmt.Exec(valSlice...)
	if err != nil {
		log.Println(SQL_INSERT, "insert data error: %v\n", err)
		return err
	}
	if LastInsertId, err := ret.LastInsertId(); nil == err {
		log.Println(SQL_INSERT, "LastInsertId:", LastInsertId)
	}
	if RowsAffected, err := ret.RowsAffected(); nil == err {
		log.Println(SQL_INSERT, "RowsAffected:", RowsAffected)
	}

	if r.Level == DEBUG {
		log.Println(SQL_ELAPSED, time.Since(l))
	}
	return nil
}



/*
	说明：插入对象到数据表中，这个方法会判读对象的各个属性，如果属性不为空，才加入插入列中；
	入参：p:插入的对象
	出参：参数1：如果出错，返回错误对象；成功返回nil
*/


func (r {{.EntityName}}List) UpdataEntity(keyNo string,p {{.EntityName}}) error {
	l := time.Now()
	var colNames string
	valSlice := make([]interface{}, 0)
	{{range .Cols}}
	{{if or (eq .ColType "int64")  (eq .ColType "int")}}
	if p.{{.ColName}} != 0 {
		colNames += "{{.ColTagName}}=?,"
		valSlice = append(valSlice, p.{{.ColName}})
	}	{{end}}	{{if eq .ColType "string" }}
	if p.{{.ColName}} != "" {
		colNames += "{{.ColTagName}}=?,"
		
		valSlice = append(valSlice, p.{{.ColName}})
	}	{{end}}	{{if eq .ColType "float64" }}
	if p.{{.ColName}} != 0.00 {
		colNames += "{{.ColTagName}}=?,"
		valSlice = append(valSlice, p.{{.ColName}})
	}	{{end}}	{{end}}
	
	colNames = strings.TrimRight(colNames, ",")
	valSlice = append(valSlice, keyNo)

	exeSql := fmt.Sprintf("update  {{.TableName}} %s  where {{.KeyColName}}=? ", colNames)
	if r.Level == DEBUG {
		log.Println(SQL_INSERT, exeSql)
	}
	stmt, err := r.DB.Prepare(exeSql)
	if err != nil {
		log.Println(SQL_ERROR, err.Error())
		return err
	}
	defer stmt.Close()

	ret, err := stmt.Exec(valSlice...)
	if err != nil {
		log.Println(SQL_INSERT, "Update data error: %v\n", err)
		return err
	}
	if LastInsertId, err := ret.LastInsertId(); nil == err {
		log.Println(SQL_INSERT, "LastInsertId:", LastInsertId)
	}
	if RowsAffected, err := ret.RowsAffected(); nil == err {
		log.Println(SQL_INSERT, "RowsAffected:", RowsAffected)
	}

	if r.Level == DEBUG {
		log.Println(SQL_ELAPSED, time.Since(l))
	}
	return nil
}

/*
	说明：根据更新主键及更新Map值更新数据表；
	入参：keyNo:更新数据的关键条件，m:更新数据列的Map
	出参：参数1：如果出错，返回错误对象；成功返回nil
*/

func (r {{.EntityName}}List) UpdateMap(keyNo string, m map[string]interface{}) error {
	l := time.Now()

	var colNames string
	valSlice := make([]interface{}, 0)
	for k, v := range m {
		colNames += k + "=?,"
		valSlice = append(valSlice, v)
	}
	valSlice = append(valSlice, keyNo)
	colNames = strings.TrimRight(colNames, ",")
	updateSql := fmt.Sprintf("Update {{.TableName}} set %s where {{.KeyColName}}=?", colNames)

	if r.Level == DEBUG {
		log.Println(SQL_UPDATE, updateSql)
	}
	stmt, err := r.DB.Prepare(updateSql)
	if err != nil {
		log.Println(SQL_ERROR, err.Error())
		return err
	}
	ret, err := stmt.Exec(valSlice...)
	if err != nil {
		log.Println(SQL_UPDATE, "Update data error: %v\n", err)
		return err
	}
	defer stmt.Close()

	if LastInsertId, err := ret.LastInsertId(); nil == err {
		log.Println(SQL_UPDATE, "LastInsertId:", LastInsertId)
	}
	if RowsAffected, err := ret.RowsAffected(); nil == err {
		log.Println(SQL_UPDATE, "RowsAffected:", RowsAffected)
	}
	if r.Level == DEBUG {
		log.Println(SQL_ELAPSED, time.Since(l))
	}
	return nil
}


/*
	说明：根据主键删除一条数据；
	入参：keyNo:要删除的主键值
	出参：参数1：如果出错，返回错误对象；成功返回nil
*/

func (r {{.EntityName}}List) Delete(keyNo string) error {
	l := time.Now()
	delSql := fmt.Sprintf("Delete from  {{.TableName}}  where {{.KeyColName}}=?")
	if r.Level == DEBUG {
		log.Println(SQL_UPDATE, delSql)
	}
	stmt, err := r.DB.Prepare(delSql)
	if err != nil {
		log.Println(SQL_ERROR, err.Error())
		return err
	}
	ret, err := stmt.Exec(keyNo)
	if err != nil {
		log.Println(SQL_DELETE, "Delete error: %v\n", err)
		return err
	}
	defer stmt.Close()

	if LastInsertId, err := ret.LastInsertId(); nil == err {
		log.Println(SQL_DELETE, "LastInsertId:", LastInsertId)
	}
	if RowsAffected, err := ret.RowsAffected(); nil == err {
		log.Println(SQL_DELETE, "RowsAffected:", RowsAffected)
	}
	if r.Level == DEBUG {
		log.Println(SQL_ELAPSED, time.Since(l))
	}
	return nil
}

