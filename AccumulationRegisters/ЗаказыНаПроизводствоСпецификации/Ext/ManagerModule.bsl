﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Обеспечение

// Возвращает текст запроса заказов на производство с переработкой на стороне для отображения в состоянии обеспечения
// при включении отбора по номенклатуре.
//
// Возвращаемое значение:
//  Строка - Текст запроса.
//
Функция ТекстЗапросаЗаказовНоменклатуры() Экспорт

	ТекстЗапроса =
		// Материалы для передачи в производство по заказу (не полностью отгруженные)
		// и работы.
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Т.ЗаказНаПроизводство КАК Заказ
		|ИЗ
		|	РегистрНакопления.ЗаказыНаПроизводствоСпецификации.Остатки(,
		|		ТипДвиженияЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыДвиженияЗапасов.Отгрузка)
		|		 И НЕ ПроизводитсяВПроцессе
		|		 И ВариантОбеспечения <> ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.НеТребуется)
		|		 {Склад.* КАК Склад, Номенклатура.* КАК Номенклатура}) КАК Т
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.ЭтапыГрафик КАК ЗаказНаПроизводствоЭтапыГрафик
		|		ПО ЗаказНаПроизводствоЭтапыГрафик.Ссылка = Т.ЗаказНаПроизводство
		|		 И ЗаказНаПроизводствоЭтапыГрафик.КодСтроки = Т.КодСтрокиЭтапыГрафик
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Этапы КАК ЗаказНаПроизводствоЭтапы
		|		ПО ЗаказНаПроизводствоЭтапы.Ссылка = Т.ЗаказНаПроизводство
		|		 И ЗаказНаПроизводствоЭтапы.КлючСвязи = ЗаказНаПроизводствоЭтапыГрафик.КлючСвязиЭтапы
		|ГДЕ
		|	ЗаказНаПроизводствоЭтапы.ПроизводствоНаСтороне
		|	ИЛИ ЗаказНаПроизводствоЭтапы.ПроизводствоНаСтороне ЕСТЬ NULL
		|		И Т.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)";

	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецЕсли