let validateInput = (input: string) : bool => {
  switch (Js.String.length(input)){
    // checking length
    | 0 => false
    | _ => 
    // checking unit type
    let isValidEnding = Js.String.endsWith(input, "pt") || Js.String.endsWith(input, "%")

    let inputValue = if Js.String.endsWith(input, "pt") {
      Js.String.slice(~from=0, ~to_=Js.String.length(input) - 2, input)
    } else if Js.String.endsWith(input, "%") {
      Js.String.slice(~from=0, ~to_=Js.String.length(input) - 1, input)
    } else {
      input
    }

    switch (Belt.Int.fromString(inputValue)){
      | None => false
      | Some(inputValue) =>
        inputValue >= 0 && inputValue <= 100 && isValidEnding
    }
  }
}