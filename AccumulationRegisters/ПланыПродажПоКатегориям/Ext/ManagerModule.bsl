﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ПланыПродажПоКатегориям";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Планы.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ПланыПродажПоКатегориям КАК Планы
	|ГДЕ
	|	Планы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.ПустаяСсылка)";
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ПланПродажПоКатегориям");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(Регистраторы,
	                                                                                  "РегистрНакопления.ПланыПродажПоКатегориям",
	                                                                                  Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли