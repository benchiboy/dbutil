package db

import (
	"database/sql"
	"fmt"
	"log"
	"strings"
	"time"

	_ "github.com/jinzhu/gorm/dialects/mysql"
)

//map for converting mysql type to golang types
var typeForMysqlToGo = map[string]string{
	"int":                "int64",
	"integer":            "int",
	"tinyint":            "int64",
	"smallint":           "int",
	"mediumint":          "int",
	"bigint":             "int64",
	"int unsigned":       "int",
	"integer unsigned":   "int",
	"tinyint unsigned":   "int",
	"smallint unsigned":  "int",
	"mediumint unsigned": "int",
	"bigint unsigned":    "int",
	"bit":                "int",
	"bool":               "bool",
	"enum":               "string",
	"set":                "string",
	"varchar":            "string",
	"char":               "string",
	"tinytext":           "string",
	"mediumtext":         "string",
	"text":               "string",
	"longtext":           "string",
	"blob":               "string",
	"tinyblob":           "string",
	"mediumblob":         "string",
	"longblob":           "string",
	"date":               "string", // time.Time
	"datetime":           "string", // time.Time
	"timestamp":          "string", // time.Time
	"time":               "string", // time.Time
	"float":              "float64",
	"double":             "float64",
	"decimal":            "float64",
	"binary":             "string",
	"varbinary":          "string",
}

type Search struct {
	TableName string
}

type ColList struct {
	DB            *sql.DB
	Cols          []Col
	ColInserts    []Col
	KeyColName    string
	KeyType       string
	Level         int
	PackageName   string
	TableName     string
	EntityName    string
	EntityTagName string
}

type Col struct {
	ColName    string
	ColTagName string
	ColType    string
	ColComment string
}

/*
	创建产品对象
*/
func New(url string, tableName string, entityName string, entityTagName string, keyColName string, packName string) *ColList {
	db, err := sql.Open("mysql", url)
	if err != nil {
		log.Println("Open database error:", err)
		return nil
	}
	if err = db.Ping(); err != nil {
		log.Println("Ping database error:", err)
		return nil
	}
	return &ColList{TableName: tableName, EntityName: entityName, EntityTagName: entityTagName, KeyColName: keyColName, PackageName: packName, DB: db}
}

//get table columes
func (r *ColList) GetList() (*ColList, error) {
	var where string
	l := time.Now()
	if r.TableName != "" {
		where = " and TABLE_NAME='" + r.TableName + "'"
	}
	qrySql := fmt.Sprintf("SELECT b.COLUMN_NAME,b.DATA_TYPE,b.COLUMN_COMMENT  FROM information_schema.COLUMNS b   WHERE  b.table_schema='tba2_db' and  1=1" + where)
	rows, err := r.DB.Query(qrySql)
	if err != nil {
		log.Println(err.Error())
		return nil, err
	}
	defer rows.Close()

	var p Col
	for rows.Next() {
		rows.Scan(&p.ColName, &p.ColType, &p.ColComment)

		p.ColTagName = p.ColName
		if p.ColName == r.KeyColName {
			r.KeyType = typeForMysqlToGo[p.ColType]
		}

		p.ColType = typeForMysqlToGo[p.ColType]

		p.ColName = r.StringToCamel2(p.ColName)

		r.Cols = append(r.Cols, p)
		//这些字段不作为插入列
		if p.ColName == "InsertTime" || p.ColName == "UpdateTime" || p.ColName == "Id" {
			continue
		} else {
			r.ColInserts = append(r.ColInserts, p)
		}
	}
	log.Println(time.Since(l))
	return r, err
}

/*
	把字符串首字母变大写
*/
func (r *ColList) StringToCamel(str string) string {
	temp := strings.Split(str, "_")
	var upperStr string
	for y := 0; y < len(temp); y++ {
		vv := []rune(temp[y])
		if y != 0 {
			for i := 0; i < len(vv); i++ {
				if i == 0 {
					vv[i] -= 32
					upperStr += string(vv[i]) // + string(vv[i+1])
				} else {
					upperStr += string(vv[i])
				}
			}
		}
	}
	return temp[0] + upperStr
}

/*
	把字符串首字母变大写
*/
func (r *ColList) StringToCamel2(str string) string {
	temp := strings.Split(str, "_")
	var upperStr string
	for y := 0; y < len(temp); y++ {
		vv := []rune(temp[y])

		for i := 0; i < len(vv); i++ {
			if i == 0 {
				vv[i] -= 32
				upperStr += string(vv[i]) // + string(vv[i+1])
			} else {
				upperStr += string(vv[i])
			}
		}
	}
	return upperStr

}
