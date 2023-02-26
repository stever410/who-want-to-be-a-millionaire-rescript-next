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

let default = ({questions, currentQuestionIndex}: props) => {
  let (selectedAnswer, setSelectedAnswer) = React.useState(_ => "")
  let (score, setScore) = React.useState(_ => 0)
  let (answers, setAnswers) = React.useState(_ => randomizeAnswers(questions[currentQuestionIndex]))

  let handleSubmit = (event: ReactEvent.Form.t, question: question) => {
    // Stop the form from submitting and refreshing the page.
    ReactEvent.Form.preventDefault(event)

    let selectedAnswer = ReactEvent.Form.target(event)["answer"]["value"]
    if selectedAnswer == question.correct_answer {
      Window.alert("Correct answer")
      setScore(v => v + 1)
    } else {
      Window.alert("The correct answer is " ++ question.correct_answer)
    }
    // Reset selected answer to initial state
    setSelectedAnswer(_ => "")
  }

  <div>
    <h1 className="text-3xl font-semibold mb-4">
      {("Your score: " ++ score->Belt.Int.toString)->React.string}
    </h1>
    <hr />
    <h1
      className="text-3xl font-semibold"
      dangerouslySetInnerHTML={"__html": questions[currentQuestionIndex].question}
    />
    <form onSubmit={event => handleSubmit(event, questions[currentQuestionIndex])}>
      <ol type_="a">
        {answers
        ->Belt.Array.mapWithIndex((index, answer) => {
          <li className="my-2" key={answer}>
            <input
              id={"answer" ++ Belt.Int.toString(index)}
              className="mr-2"
              type_="radio"
              name="answer"
              value={answer}
              onChange={e => setSelectedAnswer(ReactEvent.Form.target(e)["value"])}
            />
            <label
              dangerouslySetInnerHTML={"__html": answer}
              htmlFor={"answer" ++ Belt.Int.toString(index)}
            />
          </li>
        })
        ->React.array}
      </ol>
      <button
        type_="submit"
        disabled={selectedAnswer->Js.String.length == 0}
        className={"mt-4 btn btn-blue " ++ (
          selectedAnswer->Js.String.length == 0 ? "btn-disabled" : ""
        )}>
        {"Submit answer"->React.string}
      </button>
    </form>
  </div>
}
