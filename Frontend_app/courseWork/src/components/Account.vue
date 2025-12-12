<template>
  <main class="account-page">
    <div class="info">
      <img :src="avatar" :alt="name" v-if="imageUrl" />
      <div class="text" id="login">{{ store.state.account.login }}</div>
      <div class="text" id="tags">{{ store.state.account.password }}</div>
    </div>
  </main>
</template>

<script setup>
import {useStore} from "vuex";
import {ref, onMounted} from "vue";

const store = useStore();
const avatar = ref(null);

store.commit("setAccount");

onMounted(async () => {
  if (store.state.account["image_path"]) {
    console.log(store.state.account["image_path"]);
    avatar.value = `http://localhost:8000/api/get_image/${props.image}`;
  }
});
</script>

<style></style>
