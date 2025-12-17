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
    SET_ORDERS(state, orders) {
      state.orders = orders;
      state.settingUp = false;
    },

    SET_REPORTS(state, reports) {
      state.reports = reports;
    },

    SET_MONEY(state, money) {
      state.account.money = money;
      localStorage.setItem("account", JSON.stringify(state.account));
    },

    SET_ACCOUNT(state, account) {
      state.account = {
        ...state.account,
        ...account,
      };
      state.account.new_login = state.account.login;
      state.authenticated = true;

      localStorage.setItem("account", JSON.stringify(state.account));
      localStorage.setItem("authenticated", true);
    },
    logout(state) {
      router.push("/");
      state.authenticated = false;
      state.account = {
        new_login: "",
        login: "",
        password: "",
        avatar_path: "",
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
    async setOrders({commit}) {
      console.log("Начинаем запрос на получение заказов");

      const response = await fetch("http://localhost:8000/api/orders/get_listing");
      const data = await response.json();
      commit("SET_ORDERS", data.data);
    },
    async setReports({commit}) {
      console.log("Начинаем запрос на получение репортов");

      const response = await fetch("http://localhost:8000/api/get_reports");
      const data = await response.json();
      commit("SET_REPORTS", data.data);
    },
    async updateMoney({commit, state}) {
      console.log("Начинаем запрос на получение денег");

      const response = await fetch("http://localhost:8000/api/auth/get_money", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          login: state.account.login,
          password: state.account.password,
        }),
      });

      const data = await response.json();

      console.log(data.data);

      if (data.status === 400) {
        throw new Error("Неправильный пароль или логин");
      }
      commit("SET_MONEY", data.data);
    },

    async login({commit, state}) {
      console.log("Начинаем запрос на логирование");

      const response = await fetch("http://localhost:8000/api/auth/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          login: state.account.login,
          password: state.account.password,
        }),
      });

      const data = await response.json();

      if (data.status === 400) {
        throw new Error("Неправильный пароль или логин");
      }

      router.push("/Account");
      console.log(data.data[0]);
      commit("SET_ACCOUNT", data.data[0]);
    },
  },
});
