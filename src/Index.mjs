// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Axios from "axios";
import * as React from "react";
import * as $$Promise from "reason-promise/src/js/promise.mjs";
import * as AppConfig from "./config/AppConfig.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";

function getServerSideProps(_ctx) {
  return $$Promise.Js.map(Axios.get("/api.php?amount=" + String(AppConfig.questionAmount) + "&type=" + AppConfig.questionType, AppConfig.axiosConfig), (function (param) {
                return {
                        props: {
                          questions: param.data.results
                        }
                      };
              }));
}

function callApi(param) {
  var p = $$Promise.mapOk($$Promise.Js.toResult(Axios.get("/api.php?amount=" + String(AppConfig.questionAmount) + "&type=" + AppConfig.questionType, AppConfig.axiosConfig)), (function (param) {
          return Promise.resolve({
                      props: {
                        questions: param.data.results
                      }
                    });
        }));
  console.log(p);
  
}

function $$default(props) {
  return React.createElement("div", undefined, React.createElement("h1", {
                  className: "text-3xl font-semibold"
                }, "Who want to be a millionaire"), Belt_Array.map(props.questions, (function (question) {
                    return React.createElement("h1", {
                                key: question.question
                              }, question.question);
                  })), React.createElement("button", {
                  onClick: (function (e) {
                      return callApi(undefined);
                    })
                }, "Call API"));
}

export {
  getServerSideProps ,
  callApi ,
  $$default ,
  $$default as default,
  
}
/* axios Not a pure module */
