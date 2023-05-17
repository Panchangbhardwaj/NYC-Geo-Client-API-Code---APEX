/*<!--
- This is used to Fetch the Geo Client Details 
-===================================================
          Developer              Description      
===================================================
      Panchang Bhardwaj          NYC Geo Client - Api V2
-->*/

public class GeoClient_NYC_V2_GetResponse{
    @AuraEnabled

   //First Api -- Used To get Details for entered address usning (Street Address and Zip Code )from Geoclient API
   // URL -- https://maps.nyc.gov/geoclient/v2/search.json?input= ...
   //  Return Status  -->  'success' or 'rejected' as the status for the given input address validation.

   public static string getGeoClientDetails(String input) {
       try {
            String url = System.Label.GeoClient_API_URL + '/search.json?'
                   +'input=' + EncodingUtil.urlEncode(input, 'UTF-8')
                   +'&app_id='+System.Label.GeoClient_API_App_Id+'&app_key='+System.Label.GeoClient_API_App_Key+'&returnRejections=true'+'&returnTokens=true';
            String response = getResponse(url);
            System.debug('gc url -- '+url);
            System.debug('LocationResponse = '+response);
           return response;
       } catch (Exception e) {
           system.debug('@@@Error'+e.getMessage()+e.getLineNumber()+e.getStackTraceString());
           throw new AuraHandledException(e.getMessage());
       }
      
   }
    //Seconod Api -- Used To get AddressPoint  for provided house number ,street and zip code from Geoclient API.
    // URL -- https://maps.nyc.gov/geoclient/v2/addresspoint.json?houseNumber= ...

   @AuraEnabled
   public static String validateAddress(String houseNumber, String street, String zip){
       try {
           String url = System.Label.GeoClient_API_URL + '/addresspoint.json?'
                   +'houseNumber=' + EncodingUtil.urlEncode(houseNumber, 'UTF-8')
                   +'&street=' + EncodingUtil.urlEncode(street, 'UTF-8')
                   +'&zip=' + EncodingUtil.urlEncode(zip, 'UTF-8')           +'&app_id='+System.Label.GeoClient_API_App_Id+'&app_key='+System.Label.GeoClient_API_App_Key;
           String response = getResponse(url);
           System.debug('av url -- '+url);
           System.debug('Validation - '+response);
           return response;
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
   }
   public static string getResponse(string strURL){
       Http h = new Http();
       HttpRequest req = new HttpRequest();
       HttpResponse res = new HttpResponse();
       req.setMethod('GET');
       req.setEndpoint(strURL);
       req.setTimeout(120000);
       res = h.send(req);
       system.debug('#$'+ res.getStatusCode());
       if(res.getStatusCode() == 503){
           return '503';
       }
       String responseBody = res.getBody();
       return responseBody;
   }
}
