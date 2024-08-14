package storage

func BoxInList(ele string, list []string) bool {

	for _, listEle := range list {
		if listEle == ele {
			return true
		}
	}

	return false
}
