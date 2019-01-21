package db

import (
	"log"
	"testing"
)

func TestGetproduct(t *testing.T) {
	r := New("root:123456@tcp(10.89.4.203:3306)/tba2_db1", "tba_account_post_positions", "PostPosition", "post_positions", "post_no")
	if r == nil {
		return
	}
	l, _ := r.GetList()
	log.Println(l)
}
