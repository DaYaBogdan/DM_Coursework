<template>
  <main class="main-page">
    <div class="info">
      <div class="text">Добро пожаловать на сайт мастерской по реставрации "Асклепий"</div>
      <div class="text">Мы вновь вдохнём жизнь в уже устаревшие, но от этого, не менее дорогие для вас вещи</div>
      <div class="text">Чтобы продолжить, пожалуйста, зарегестрируйтесь или войдите в аккаунт</div>
    </div>
    <div class="aligned-info">
      <div v-if="store.state.authenticated"><Account /></div>
      <div class="align" v-else>
        <Registration />
        <RouterLink class="just-text" :to="{name: 'Авторизация'}">Зарегестрированы?</RouterLink>
      </div>
      <div><Carousel /></div>
    </div>
  </main>
</template>

<script setup>
import Account from "./Account.vue";
import Registration from "./Registration.vue";
import Carousel from "./Carousel.vue";
import {useStore} from "vuex";

const store = useStore();
</script>

<style lang="scss" scoped>
.align {
  align-items: center;
  justify-content: center;
  text-align: center;
}

.just-text {
  font-size: 2rem;
  padding: 2rem;
  align-items: center;
}

a {
  text-decoration: none;
  &:link {
    color: var(--dark);
  }
  &:visited {
    color: var(--primary-alt);
  }
}
</style>
