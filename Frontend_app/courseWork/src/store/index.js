import {createStore} from "vuex";
import router from "@/router";

export default createStore({
  state: {
    orders: [],
    settingUp: true,

    account: {
      new_login: "",
      login: "",
      password: "",
      avatar_path: "",
      fio: "",
      email: "",
      phone: "",
      money: 0,
      role: "",
    },
    authenticated: false,

    reports: [],
    types: [],
  },
  mutations: {
    setOrders(state) {
      console.log("Начинаем запрос на получение заказов");
      fetch("http://localhost:8000/api/orders/get_listing")
        .then((response) => response.json())
        .then((data) => (state.orders = data["data"]))
        .catch((error) => {
          console.error("Ошибка", error);
          return;
        })
        .then((state.settingUp = false));
    },
    login(state) {
      console.log("Начинаем запрос на логирование");
      fetch("http://localhost:8000/api/auth/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({login: state.account["login"], password: state.account["password"]}),
      })
        .then((response) => response.json())
        .then((data) => {
          if (data["status"] === 400) {
            throw new Error("Неправильный пароль или логин");
          } else {
            state.account = {
              new_login: data["data"][0].login,
              login: data["data"][0].login,
              password: data["data"][0].password,
              avatar_path: data["data"][0].avatar_path,
              fio: data["data"][0].fio,
              email: data["data"][0].email,
              phone: data["data"][0].phone,
              money: data["data"][0].money,
              role: data["data"][0].role,
            };
            state.authenticated = true;
            router.push("/Account");
            localStorage.setItem("account", JSON.stringify(state.account));
            localStorage.setItem("authenticated", JSON.stringify(state.authenticated));
            return;
          }
        })
        .catch((error) => {
          console.error("Ошибка: ", error);
          return;
        });
    },
    logout(state) {
      router.push("/");
      state.authenticated = false;
      state.account = {
        new_login: "",
        login: "",
        password: "",
        image_path: "",
        fio: "",
        email: "",
        phone: "",
        money: 0,
        role: "",
      };
      localStorage.setItem("account", JSON.stringify(state.account));
      localStorage.setItem("authenticated", JSON.stringify(state.authenticated));
    },
    setAccount(state) {
      try {
        state.account = JSON.parse(localStorage.getItem("account"));
        state.authenticated = JSON.parse(localStorage.getItem("authenticated"));
        if (!state.account) {
          logout(state);
        }
      } catch {
        state.authenticated = false;
        state.account = {
          login: "",
          password: "",
          image_path: "",
          fio: "",
          email: "",
          phone: "",
          money: 0,
          role: "",
        };
        localStorage.setItem("account", JSON.stringify(state.account));
        localStorage.setItem("authenticated", JSON.stringify(state.authenticated));
      }
    },
    changeAccountProperties(state) {
      fetch("http://localhost:8000/api/account_update", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          new_login: state.account["new_login"],
          login: state.account["login"],
          password: state.account["password"],
          fio: state.account["fio"],
          email: state.account["email"],
          phone: state.account["phone"],
          role: state.account["role"],
        }),
      })
        .then(() => (state.account["login"] = state.account["new_login"]))
        .then(() => {
          localStorage.setItem("account", JSON.stringify(state.account));
          localStorage.setItem("authenticated", JSON.stringify(state.authenticated));
        })
        .catch((error) => {
          console.error("Ошибка: ", error);
          return;
        });
    },
    getReports(state) {
      console.log("Начинаем запрос на получение репортов");
      fetch("http://localhost:8000/api/get_reports")
        .then((response) => response.json())
        .then((data) => (state.reports = data["data"]))
        .catch((error) => {
          console.error("Ошибка", error);
          return;
        });
    },
    sendReport(state, {reported, description}) {
      fetch("http://localhost:8000/api/send_report", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          reporter: state.account["login"],
          reported: reported,
          description: description,
        }),
      });
      return;
    },
    setTypes(state, types) {
      state.types = types;
    },
  },
  actions: {
    async fetchTypes({commit}) {
      try {
        const response = await fetch("http://localhost:8000/api/all_types");
        const data = await response.json();
        commit("setTypes", data.data);
      } catch (e) {
        console.error("Ошибка", e);
      }
    },
  },
});
