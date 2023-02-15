open AppConfig

type props = {mutable questions: array<question>}

type data = {results: array<question>, response_code: int}

let getServerSideProps = _ctx => {
  Axios.get(
    `/api.php?amount=${questionAmount->Belt.Int.toString}&type=${questionType}`,
    ~config=axiosConfig,
    (),
  )->Promise.Js.map(({data}) => {
    let response: data = data
    {
      "props": {
        questions: response.results,
      },
    }
  })
}

let callApi = () => {
  let p =
    Axios.get(
      `/api.php?amount=${questionAmount->Belt.Int.toString}&type=${questionType}`,
      ~config=axiosConfig,
      (),
    )
    ->Promise.Js.toResult
    ->Promise.mapOk(({data}) => {
      let responseData: data = data
      {
        "props": {
          questions: responseData.results,
        },
      }->Js.Promise.resolve
    })
  Js.log(p)
}

let default = (props: props) =>
  <div>
    <h1 className="text-3xl font-semibold"> {"Who want to be a millionaire"->React.string} </h1>
    {props.questions
    ->Belt.Array.map(question => {
      <h1 key={question.question}> {question.question->React.string} </h1>
    })
    ->React.array}
    <button onClick={e => callApi()}> {"Call API"->React.string} </button>
  </div>
