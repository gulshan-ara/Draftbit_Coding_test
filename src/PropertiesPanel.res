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
  type margin = {
    id: int,
    margin_top: int,
    margin_bottom: int,
    margin_left: int,
    margin_right: int,
  }

  @react.component
  let make = () => {
    let (margin: option<array<margin>>, setMargin) = React.useState(_ => None)

    React.useEffect1(() => {
      // Fetch the data from /examples and set the state when the promise resolves
      Fetch.fetchJson(`http://localhost:12346/margins`)
      |> Js.Promise.then_(marginJson => {
        // NOTE: this uses an unsafe type cast, as safely parsing JSON in rescript is somewhat advanced.
        Js.Promise.resolve(setMargin(_ => Some(Obj.magic(marginJson))))
      })
      // The "ignore" function is necessary because each statement is expected to return `unit` type, but Js.Promise.then return a Promise type.
      |> ignore
      None
    }, [setMargin])

  <div className="Prism-container">
  {
      switch margin {
      | None => React.string("Loading margins....")
      | Some(margin) =>
        margin
        ->Js.Array2.map(m =>
          <div className="margin-grid">
            <input className="margin-input top" type_="text" value={Js.Int.toString(m.margin_top)} />
            <input className="margin-input left" type_="text" value={Js.Int.toString(m.margin_left)} />
            <div className="content-box">
              <div className="padding-grid">
                <input className="padding-input top" type_="text" value={Js.Int.toString(m.margin_top)} />
                <input className="padding-input left" type_="text" value={Js.Int.toString(m.margin_left)} />
                <input className="padding-input right" type_="text" value={Js.Int.toString(m.margin_right)} />
                <input className="padding-input bottom" type_="text" value={Js.Int.toString(m.margin_bottom)} />
              </div>
            </div>
            <input className="margin-input right" type_="text" value={Js.Int.toString(m.margin_right)} />
            <input className="margin-input bottom" type_="text" value={Js.Int.toString(m.margin_bottom)} />
          </div>
        )
        ->React.array
      }
    }
  </div>

  }
}

@genType @genType.as("PropertiesPanel") @react.component
let make = () =>
  <aside className="PropertiesPanel">
    <Collapsible title="Load examples"> <ViewExamples /> </Collapsible>
    <Collapsible title="Margins & Padding">
      <span> <Prism /> </span>
    </Collapsible>
    <Collapsible title="Size"> <span> {React.string("example")} </span> </Collapsible>
  </aside>
