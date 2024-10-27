%raw(`require("./PropertiesPanel.css")`)

module Collapsible = {
  @react.component
  let make = (~title, ~children) => {
    let (collapsed, toggle) = React.useState(() => false)

    <section className="Collapsible">
      <button className="Collapsible-button" onClick={_e => toggle(_ => !collapsed)}>
        <span> {React.string(title)} </span> <span> {React.string(collapsed ? "+" : "-")} </span>
      </button>
      {collapsed ? React.null : <div className="Collapsible-content"> {children} </div>}
    </section>
  }
}

// This component provides a simplified example of fetching JSON data from
// the backend and rendering it on the screen.
module ViewExamples = {
  // Type of the data returned by the /examples endpoint
  type example = {
    id: int,
    some_int: int,
    some_text: string,
  }

  @react.component
  let make = () => {
    let (examples: option<array<example>>, setExamples) = React.useState(_ => None)

    React.useEffect1(() => {
      // Fetch the data from /examples and set the state when the promise resolves
      Fetch.fetchJson(`http://localhost:12346/examples`)
      |> Js.Promise.then_(examplesJson => {
        // NOTE: this uses an unsafe type cast, as safely parsing JSON in rescript is somewhat advanced.
        Js.Promise.resolve(setExamples(_ => Some(Obj.magic(examplesJson))))
      })
      // The "ignore" function is necessary because each statement is expected to return `unit` type, but Js.Promise.then return a Promise type.
      |> ignore
      None
    }, [setExamples])

    <div>
      {switch examples {
      | None => React.string("Loading examples....")
      | Some(examples) =>
        examples
        ->Js.Array2.map(example =>
          React.string(`Int: ${example.some_int->Js.Int.toString}, Str: ${example.some_text}`)
        )
        ->React.array
      }}
    </div>
  }
}

module Prism = {
  type marginPadding = {
    id: int,
    margin_top: string,
    margin_bottom: string,
    margin_left: string,
    margin_right: string,
    padding_top: string,
    padding_bottom: string,
    padding_left: string,
    padding_right: string,
  }

  @react.component
  let make = () => {
    let (margin: option<array<marginPadding>>, setMargin) = React.useState(_ => None)

    React.useEffect1(() => {
      // Fetch the data from /examples and set the state when the promise resolves
      Fetch.fetchJson(`http://localhost:12346/margin-padding`)
      |> Js.Promise.then_(marginJson => {
        Js.log(marginJson)
        // NOTE: this uses an unsafe type cast, as safely parsing JSON in rescript is somewhat advanced.
        Js.Promise.resolve(setMargin(_ => Some(Obj.magic(marginJson))))
      })
      // The "ignore" function is necessary because each statement is expected to return `unit` type, but Js.Promise.then return a Promise type.
      |> ignore
      None
    }, [setMargin])

    let handleInputChange = (id, field, value) => {
      switch margin {
      | None => ()
      | Some(data) =>
        let updatedData = data->Js.Array2.map(m => {
          if m.id === id {
            switch field {
            | "margin_top" => {...m, margin_top: value}
            | "margin_left" => {...m, margin_left: value}
            | "margin_right" => {...m, margin_right: value}
            | "margin_bottom" => {...m, margin_bottom: value}
            | "padding_top" => {...m, padding_top: value}
            | "padding_left" => {...m, padding_left: value}
            | "padding_right" => {...m, padding_right: value}
            | "padding_bottom" => {...m, padding_bottom: value}
            | _ => m
            }
          } else {
            m
          }
        })
        setMargin(_ => Some(updatedData))
      }
    }

    let updateDatabase = (id, updatedItem) => {
      let body = Js.Json.stringify(Js.Json.object_(updatedItem))

      let headers = Js.Dict.empty()
      Js.Dict.set(headers, "Content-Type", "application/json")

      let method: option<string> = Some("PUT")

      Fetch.fetch(
        `http://localhost:12346/margin-padding/${id}`,
        {
          method: method,
          headers: headers,
          body: Some(body),
        },
      ) |> ignore
    }

    <div className="Prism-container">
      {switch margin {
      | None => React.string("Loading margins....")
      | Some(margin) =>
        margin
        ->Js.Array2.map(m =>
          <div className="margin-grid">
            <input
              className="margin-input top"
              type_="text"
              value={m.margin_top}
              onChange={(ev: ReactEvent.Form.t) =>
                handleInputChange(m.id, "margin_top", ReactEvent.Form.target(ev)["value"])}
              onBlur={_ => updateDatabase(Belt.Int.toString(m.id), Obj.magic(m))}
            />
            <input
              className="margin-input left"
              type_="text"
              value={m.margin_left}
              onChange={(ev: ReactEvent.Form.t) =>
                handleInputChange(m.id, "margin_left", ReactEvent.Form.target(ev)["value"])}
              onBlur={_ => updateDatabase(Belt.Int.toString(m.id), Obj.magic(m))}
            />
            <div className="content-box">
              <div className="padding-grid">
                <input
                  className="padding-input top"
                  type_="text"
                  value={m.padding_top}
                  onChange={(ev: ReactEvent.Form.t) =>
                    handleInputChange(m.id, "padding_top", ReactEvent.Form.target(ev)["value"])}
                  onBlur={_ => updateDatabase(Belt.Int.toString(m.id), Obj.magic(m))}
                />
                <input
                  className="padding-input left"
                  type_="text"
                  value={m.padding_left}
                  onChange={(ev: ReactEvent.Form.t) =>
                    handleInputChange(m.id, "padding_left", ReactEvent.Form.target(ev)["value"])}
                  onBlur={_ => updateDatabase(Belt.Int.toString(m.id), Obj.magic(m))}
                />
                <input
                  className="padding-input right"
                  type_="text"
                  value={m.padding_right}
                  onChange={(ev: ReactEvent.Form.t) =>
                    handleInputChange(m.id, "padding_right", ReactEvent.Form.target(ev)["value"])}
                  onBlur={_ => updateDatabase(Belt.Int.toString(m.id), Obj.magic(m))}
                />
                <input
                  className="padding-input bottom"
                  type_="text"
                  value={m.padding_bottom}
                  onChange={(ev: ReactEvent.Form.t) =>
                    handleInputChange(m.id, "padding_bottom", ReactEvent.Form.target(ev)["value"])}
                  onBlur={_ => updateDatabase(Belt.Int.toString(m.id), Obj.magic(m))}
                />
              </div>
            </div>
            <input
              className="margin-input right"
              type_="text"
              value={m.margin_right}
              onChange={(ev: ReactEvent.Form.t) =>
                handleInputChange(m.id, "margin_right", ReactEvent.Form.target(ev)["value"])}
              onBlur={_ => updateDatabase(Belt.Int.toString(m.id), Obj.magic(m))}
            />
            <input
              className="margin-input bottom"
              type_="text"
              value={m.margin_bottom}
              onChange={(ev: ReactEvent.Form.t) =>
                handleInputChange(m.id, "margin_bottom", ReactEvent.Form.target(ev)["value"])}
              onBlur={_ => updateDatabase(Belt.Int.toString(m.id), Obj.magic(m))}
            />
          </div>
        )
        ->React.array
      }}
    </div>
  }
}

@genType @genType.as("PropertiesPanel") @react.component
let make = () =>
  <aside className="PropertiesPanel">
    <Collapsible title="Load examples"> <ViewExamples /> </Collapsible>
    <Collapsible title="Margins & Padding"> <span> <Prism /> </span> </Collapsible>
    <Collapsible title="Size"> <span> {React.string("example")} </span> </Collapsible>
  </aside>
