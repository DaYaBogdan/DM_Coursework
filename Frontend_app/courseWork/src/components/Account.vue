<template>
  <main class="account-page">
    <div class="info">
      <img :src="image" v-if="image" />
      <div class="text" id="login">{{ store.state.account.login }}</div>
      <div class="text" id="tags">{{ store.state.account.password }}</div>
    </div>
  </main>
</template>

<script setup>
import {useStore} from "vuex";
import {ref, onMounted, computed} from "vue";

const store = useStore();
const image = ref(null);

onMounted(async () => {
  console.log(store.state.account[0].avatar_path);
  image.value = `http://localhost:8000/api/get_image/${store.state.account[0].avatar_path}`;
});
</script>

<style></style>
