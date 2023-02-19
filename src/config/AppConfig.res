let axiosConfig = Axios.makeConfig(~baseURL="https://opentdb.com", ())
let questionAmount = 10
let questionType = "multiple"

type question = {
  category: string,
  correct_answer: string,
  difficulty: string,
  question: string,
  incorrect_answers: array<string>,
}
