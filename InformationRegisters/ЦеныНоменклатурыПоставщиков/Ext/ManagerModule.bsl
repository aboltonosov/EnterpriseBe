﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрСведений.ЦеныНоменклатурыПоставщиков";
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Цены.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыПоставщиков КАК Цены
	|ГДЕ
	|	Цены.ВидЦеныПоставщика.Владелец ССЫЛКА Справочник.Партнеры
	|		И Цены.ВидЦеныПоставщика.Владелец <> Цены.Партнер
	|		И (Цены.Регистратор ССЫЛКА Документ.ЗаказПоставщику
	|			ИЛИ Цены.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ПоступлениеТоваровУслуг.Ссылка
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	|ГДЕ
	|	ПоступлениеТоваровУслуг.ЦенаВключаетНДС
	|	И ПоступлениеТоваровУслуг.РегистрироватьЦеныПоставщика
	|");
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрСведений.ЦеныНоменклатурыПоставщиков";
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ЗаказПоставщику");
	Регистраторы.Добавить("Документ.ПоступлениеТоваровУслуг");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(Регистраторы,
	                                                                                  ПолноеИмяРегистра,
	                                                                                  Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли