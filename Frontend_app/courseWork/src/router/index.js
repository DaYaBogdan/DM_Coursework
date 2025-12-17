import {createRouter, createWebHistory} from "vue-router";
import HomePage from "@/components/HomePage.vue";
import Account from "@/components/Account.vue";
import Orders from "@/components/Orders.vue";
import Reports from "@/components/Reports.vue";
import Workers from "@/components/Workers.vue";
import Materials from "@/components/Materials.vue";
import Authorisation from "@/components/Authorisation.vue";
import Carousel from "@/components/Carousel.vue";
import MakeOrder from "@/components/MakeOrder.vue";
import Error from "@/components/Error.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "Главная страница",
      component: HomePage,
      children: {
        path: "/",
        name: "Карусель",
        component: Carousel,
      },
    },
    {
      path: "/Account",
      name: "Аккаунт",
      component: Account,
    },
    {
      path: "/Orders",
      name: "Ваши заказы",
      component: Orders,
    },
    {
      path: "/Reports",
      name: "Книга жалоб",
      component: Reports,
    },
    {
      path: "/Workers",
      name: "Сотрудники",
      component: Workers,
    },
    {
      path: "/Materials",
      name: "Материалы",
      component: Materials,
    },
    {
      path: "/Authorise",
      name: "Авторизация",
      component: Authorisation,
    },
    {
      path: "/makeOrder",
      name: "Сделать заказ",
      component: MakeOrder,
    },
    {
      path: "/catchall(.*)",
      name: "Ошибка 404",
      component: Error,
    },
  ],
});

export default router;
