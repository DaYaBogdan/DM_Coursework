import {createStore} from "vuex";
import {ref} from "vue";

export default createStore({
  state: {
    orders: [],
    settingUp: true,

    account: {
      login: ref(""),
      password: ref(""),
      image_path: "",
      fio: "",
      email: "",
      phone: "",
      money: 0,
      role: "",
    },
    authenticated: false,
  },
  getters: {},
  mutations: {
    setOrders(state) {
      setInterval(function () {
        console.log("Начинаем запрос на получение заказов");
        fetch("http://localhost:8000/api/orders/get_listing")
          .then((response) => response.json())
          .then((data) => (state.orders = data["data"]))
          .catch((error) => {
            console.error("Ошибка", error);
            return;
          })
          .then((state.settingUp = false));
      }, 3000);
    },
    setAccountData(state) {
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
          if (data["status"] == 400) {
            throw "Неправильный пароль или логин";
          }
        })
        .then((data) => (state.account = data["data"]))
        .catch((error) => {
          console.error("Ошибка: ", error);
          return;
        })
        .then((state.authenticated = true));
    },
  },
  actions: {},
});
