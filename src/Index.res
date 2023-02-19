open AppConfig
module Window = {
  @scope("window") @val
  external alert: string => unit = "alert"
}

type props = {questions: array<question>, currentQuestionIndex: int}

type data = {results: array<question>, response_code: int}

let initialProps = {
  currentQuestionIndex: 0,
  questions: [],
}

let getServerSideProps = _ctx => {
  Axios.get(
    `/api.php?amount=${questionAmount->Belt.Int.toString}&type=${questionType}`,
    ~config=axiosConfig,
    (),
  )->Promise.Js.map(({data}) => {
    let response: data = data
    {
      "props": {
        ...initialProps,
        questions: response.results,
      },
    }
  })
}

let randomizeAnswers = (question: question) => {
  Belt.Array.concat([question.correct_answer], question.incorrect_answers)->Belt.Array.shuffle
}

let handleSubmit = (event: ReactEvent.Form.t, question: question) => {
  // Stop the form from submitting and refreshing the page.
  ReactEvent.Form.preventDefault(event)

  let selectedAnswer = ReactEvent.Form.target(event)["answer"]["value"]
  if selectedAnswer == question.correct_answer {
    Window.alert("Correct answer")
  } else {
    Window.alert("The correct answer is " ++ question.correct_answer)
  }
}

let default = ({questions, currentQuestionIndex}: props) =>
  <div>
    <h1
      className="text-3xl font-semibold"
      dangerouslySetInnerHTML={"__html": questions[currentQuestionIndex].question}
    />
    <form onSubmit={event => handleSubmit(event, questions[currentQuestionIndex])}>
      <ol type_="a">
        {randomizeAnswers(questions[currentQuestionIndex])
        ->Belt.Array.mapWithIndex((index, answer) => {
          <li className="my-2" key={answer}>
            <input
              id={"answer" ++ Belt.Int.toString(index)}
              className="mr-2"
              type_="radio"
              name="answer"
              value={answer}
            />
            <label> {answer->React.string} </label>
          </li>
        })
        ->React.array}
      </ol>
      <button
        type_="submit"
        className="mt-4 bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white py-2 px-4 border border-blue-500 hover:border-transparent rounded">
        {"Submit answer"->React.string}
      </button>
    </form>
  </div>
