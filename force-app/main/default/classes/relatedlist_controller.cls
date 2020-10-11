/**
 * @description       : Visualforce component Controller class (CustomRelatedlist.component)
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-12-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-11-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class relatedlist_controller {

    public List<Student_wrapper> maindata    {get { return calculateInfo(); } set;}
    public GenericDataWrapper    dataSource  {get; set{ Boolean changed = (value != dataSource); dataSource = value; setinfo(changed); }}
    public String                footerText  {get { return dataManager.getGenericInfo(); }}
    public CustomController      dataManager {get; set;}
    public vsPage1_Controller    controller  {get; set;}

    /**
    * @description Constructor (not necessary)
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    **/
    public relatedlist_controller() { }
    private List<Student_wrapper> calculateInfo() {
        if (dataSource == null || dataSource.studentData == null || dataSource.studentData.isEmpty()) return new List<Student_wrapper>();
        return dataManager.currentData;
    }
    /**
    * @description Everyting is initilized only when new data is set from the main page
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param isChanged Checks if the data received are new from the main page or simple rerender (avoid unnecessary logic)
    **/
    private void setInfo(Boolean isChanged){
        if (dataSource == null || dataSource.studentData == null) dataManager = new CustomController(new List<Student_wrapper>());
        else if (isChanged) dataManager = new CustomController(dataSource.studentData);
    }

    /*
     * Standard set controller cant manage with wrappers like Student_wrapper, that's why it is necessary to build a custom controller
     * 
     */
    public class CustomController {

        public Boolean hasNext       {get { return source == null ? false : (position + recordPerPage) < source.size(); }}
        public Boolean hasPrev       {get { return source == null ? false : (position != 0); }}
        public Integer currentPage   {get; set;}
        public Integer totalPages    {get; set;}
        public Integer recordPerPage {get; set;}
        public Integer position      {get; set;}
        public Boolean changed;
        public List<Student_wrapper> currentData {get { if (source == null) return new List<Student_wrapper>(); setCurrent(); return currentData; } set; }

        private List<Student_wrapper> source;

        public CustomController(List<Student_wrapper> data) {
            source  = data;
            changed = false;
            if (source != null) {
                position      = 0;
                recordPerPage = 20;
                totalPages    = integer.valueOf(((Decimal)((Decimal)source.size() / (Decimal)recordPerPage)).round(System.RoundingMode.UP));
                currentPage   = 1;
                changed       = true;
            }
        }

        public String getGenericInfo() {
            String testo;
            if (source == null || source.isEmpty()) testo = '<i>Non ci sono record da visualizzare</i>';
            else testo = 'Risultati : <b>' + source.size() + '</b> - Pagina ' + currentPage + ' / ' + totalPages + ' Record visualizzati : <b>' + currentData.size() + '</b>';
            return testo;
        }

        public void goNext()  { if (hasNext) { position += recordPerPage; currentPage++; changed = true; }}
        public void goPrev()  { if (hasPrev) { position -= recordPerPage; currentPage--; changed = true; }}
        public void goStart() { while (hasPrev) goPrev(); }
        public void goEnd()   { while (hasNext) goNext(); }

        public void setCurrent() {
            if (changed) {
                List<Student_wrapper> result = new List<Student_wrapper>();
                Integer limite = hasNext ? (position + recordPerPage) : source.size();
                for (Integer x = position; x < limite; x++) {
                    result.add(source[x]);
                }
                currentData = result;
                System.debug(position);
                changed  = false;
            }
        }

    }
}