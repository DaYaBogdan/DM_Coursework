<template>
  <main class="auth-page">
    <div class="aligned-info">
      <Registration />
      <Login />
    </div>
    <div class="info">
      <div class="text">Пройдя регистрацию вы получите доступ к функционала сайта</div>
      <div class="text">Постить заказы, просматривать их даже оставлять жалобы в книге жалоб</div>
      <div class="text">
        Помимо этого вы соглашаетесь с нашей политикой конфиденциальности и даёте своё согласие на обработку данных вашей учётной записи
      </div>
    </div>
  </main>
</template>

<script setup>
import Login from "./Login.vue";
import Registration from "./Registration.vue";
</script>

<style></style>
