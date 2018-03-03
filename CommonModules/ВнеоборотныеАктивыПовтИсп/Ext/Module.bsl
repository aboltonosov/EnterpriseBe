﻿#Область ПрограммныйИнтерфейс

// Функция возвращает признак необходимости настройки отражения расходов по имущественным налогам
//
// Параметры:
//  ГруппаОС  - ПеречислениеСсылка.ГруппыОС - Группа основного средства
//
// Возвращаемое значение:
//  Результат - Булево - Истина - требуется настройка
//  				   - Ложь  - настройка не требуется
//
Функция ТребуетсяНастройкаОтраженияРасходовПоНалогам(ГруппаОС) Экспорт
	
	ГруппыОС = Новый Массив;
	ГруппыОС.Добавить(Перечисления.ГруппыОС.Здания);
	ГруппыОС.Добавить(Перечисления.ГруппыОС.Сооружения);
	ГруппыОС.Добавить(Перечисления.ГруппыОС.ЗемельныеУчастки);
	ГруппыОС.Добавить(Перечисления.ГруппыОС.ПрочееИмуществоТребующееГосударственнойРегистрации);
	ГруппыОС.Добавить(Перечисления.ГруппыОС.ТранспортныеСредства);
	ГруппыОС.Добавить(Перечисления.ГруппыОС.МноголетниеНасаждения);
	
	Результат = (ГруппыОС.Найти(ГруппаОС) <> Неопределено);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти