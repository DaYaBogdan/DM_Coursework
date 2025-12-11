<script setup>
import {ref} from "vue";

const is_expanded = ref(localStorage.getItem("is_expanded") === "true");
const ToggleMenu = () => {
  is_expanded.value = !is_expanded.value;

  localStorage.setItem("is_expanded", is_expanded.value);
};
</script>

<template>
  <aside :class="`${is_expanded && 'is-expanded'}`">
    <div class="logo">
      <img src="/favicon.ico" alt="Vue" />
    </div>
    <div class="menu-toggle-wrap">
      <button class="menu-toggle" @click="ToggleMenu">
        <span class="material-icons">keyboard_double_arrow_right</span>
      </button>
    </div>
    <div class="menu">
      <h3>Меню</h3>
      <RouterLink class="button" :to="{name: 'Главная страница'}"
        ><span class="material-icons"> home </span>
        <span class="text">Главная страница</span>
      </RouterLink>
      <RouterLink class="button" :to="{name: 'Аккаунт'}">
        <span class="material-icons"> account_circle </span>
        <span class="text">Аккаунт</span>
      </RouterLink>
      <RouterLink class="button" :to="{name: 'Ваши заказы'}">
        <span class="material-icons"> list_alt </span>
        <span class="text">Ваши заказы</span>
      </RouterLink>
      <RouterLink class="button" :to="{name: 'Книга жалоб'}">
        <span class="material-icons"> report </span>
        <span class="text">Книга жалоб</span>
      </RouterLink>
      <!-- <div class="master-text">---- Панель администратора ----</div> -->
      <RouterLink class="button" :to="{name: 'Сотрудники'}">
        <span class="material-icons"> engineering </span>
        <span class="text">Сотрудники</span>
      </RouterLink>
      <RouterLink class="button" :to="{name: 'Материалы'}">
        <span class="material-icons"> warehouse </span>
        <span class="text">Материалы</span>
      </RouterLink>
    </div>

    <div class="flex"></div>

    <div class="menu">
      <RouterLink class="button" :to="{name: 'Авторизация'}">
        <span class="material-icons"> login </span>
        <span class="text">Авторизация</span>
      </RouterLink>
    </div>
  </aside>
</template>

<style lang="scss" scoped>
aside {
  display: flex;
  flex-direction: column;
  width: calc(2rem + 32px);
  min-height: 100vh;
  overflow: hidden;
  padding: 1rem;

  background-color: var(--dark);
  color: var(--light);

  transition: 0.2s ease-out;

  .flex {
    flex: 1 1 0;
  }

  @media (max-width: 768px) {
    position: fixed;
    z-index: 99;
  }

  .logo {
    margin-bottom: 1rem;

    img {
      width: 2rem;
    }
  }

  .menu-toggle-wrap {
    display: flex;
    justify-content: flex-end;
    margin-bottom: 1rem;
    margin-left: 0;

    position: relative;
    top: 0;
    transition: 0.2s ease-out;

    .menu-toggle {
      transition: 0.2s ease-out;

      .material-icons {
        font-size: 2rem;
        color: var(--light);
      }

      &:hover {
        .material-icons {
          color: var(--primary);
          transform: translateX(0.5rem);
        }
      }
    }
  }

  h3,
  .button .text,
  .master-text {
    opacity: 0;
    transition: 0.3s ease-out;
  }

  h3 {
    padding: 0rem 1rem;
    color: var(--grey);
    font-size: 0.875rem;
    margin-bottom: 0.5rem;
    text-transform: uppercase;
  }

  .menu {
    margin: 0 -1rem;

    .button {
      display: flex;
      align-items: center;
      text-decoration: none;

      padding: 0.5rem 1rem;
      transition: 0.2s ease-out;

      .material-icons {
        font-size: 2rem;
        color: var(--light);
        transition: 0.2s ease-out;
      }

      .text {
        color: var(--light);
        transition: 0.2s ease-out;
      }

      &:hover,
      &.router-link-exact-active {
        background-color: var(--dark-alt);

        .material-icons,
        .text {
          color: var(--primary);
        }
      }

      &.router-link-exact-active {
        border-right: 5px solid var(--primary);
      }
    }

    .master-text {
      padding: 20px 10px;
      text-align: center;
      color: var(--light);
      transition: 0.2s ease-out;
    }
  }

  &.is-expanded {
    width: var(--sidebar-width);

    .menu-toggle-wrap {
      top: -3rem;
      .menu-toggle {
        transform: rotate(-180deg);
      }
    }

    .menu-toggle-wrap {
      top: -3rem;
    }

    h3,
    .button .text,
    .master-text {
      opacity: 1;
    }

    .button {
      .material-icons {
        margin-right: 1rem;
      }
    }
  }
}
</style>
