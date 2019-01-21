package t2s

import (
	"dbutil/db"
	"io/ioutil"
	"log"
	"os"

	"text/template"
)

func Table2Struct2() error {
	redBuf, _ := ioutil.ReadFile(".\\tmpl.pl")
	tbs := db.New("root:123456@tcp(10.89.4.213:3306)/likemi", "tba_account_post_resumes", "PostResume", "post_resume", "post_no")
	s := db.Search{TableName: "tba_account_post_resumes"}
	colList, _ := tbs.GetList(s)
	log.Println(colList.Cols)
	t := template.Must(template.New("testing").Parse(string(redBuf)))
	t.Execute(os.Stdout, colList)

	return nil
}
