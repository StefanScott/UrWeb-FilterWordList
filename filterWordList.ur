table thing : {
  Nam : string
}

fun filterRows aFilter anOffset = 
  case aFilter of
      "" =>
        queryX1 
          ( SELECT thing.Nam 
            FROM thing 
            ORDER BY thing.Nam 
            LIMIT 50 
            OFFSET {anOffset} )
          (fn r => <xml>{[r.Nam]}<br/></xml>)
    | _ =>
        queryX1 
          ( SELECT thing.Nam 
            FROM thing 
            WHERE thing.Nam LIKE {['%' ^ aFilter ^ '%']} 
            ORDER BY thing.Nam 
            LIMIT 50 
            OFFSET {anOffset} )
          (fn r => <xml>{[r.Nam]}<br/></xml>)

fun main () =
  theLang <- source "";
  theFilter <- source "" ;
  theOffset <- source 0;  
  rows <- source <xml/> ;
  return 
  <xml>
    <body onload={rows' <- rpc (filterRows "" 0); set rows rows'}>
      <cselect source={theLang} >
        <coption value="Enter letters [a-z]* to filter a list of 192,425 English words.">EN</coption>
        <coption value="Введите буквы [a-z]*, чтобы отфильтровать список 192.425 английских слов.">RU</coption>
        <coption value="Introduzca letras [a-z]* para filtrar una lista de 192.425 palabras en inglés.">ES</coption>
        <coption value="Geben Sie Buchstaben [a-z]*, um eine Liste von 192.425 englischen Wörtern zu filtern.">DE</coption>
        <coption value="Saisissez des lettres [a-z]* pour filtrer une liste de 192 425 mots anglais.">FR</coption>
        <coption value="Digite letras [a-z]* para filtrar uma lista de 192.425 palavras em inglês.">PT</coption>
      </cselect>
      <dyn signal={theLang' <- signal theLang; return <xml>{[theLang']}</xml>}/>
      <br/>
      <br/>
      <ctextbox 
        source={theFilter}
        onkeyup={
          fn _ =>
            set theOffset 0 ;
            theFilter' <- get theFilter ;
            theOffset' <- get theOffset ;
            rows' <- rpc (filterRows theFilter' theOffset') ; 
            set rows rows'
        }
      />
      <br/>
      <br/>
      <button 
        value="<" 
        onclick={
          fn _ => 
            theOffset' <- get theOffset ;
            set theOffset (if theOffset' >= 50 then theOffset' - 50 else 0) ;
            theOffset' <- get theOffset ;
            theFilter' <- get theFilter ;
            rows' <- rpc (filterRows theFilter' theOffset') ; 
            set rows rows'
        }/>
      <button 
        value=">" 
        onclick={
          fn _ => 
            theOffset' <- get theOffset ;
            set theOffset (theOffset' + 50) ;
            theOffset' <- get theOffset ;
            theFilter' <- get theFilter ;
            rows' <- rpc (filterRows theFilter' theOffset') ; 
            set rows rows'
        }/>
      <br/>
      <dyn signal={
        rows' <- signal rows ; 
        return rows'
      }/>
    </body>
  </xml>