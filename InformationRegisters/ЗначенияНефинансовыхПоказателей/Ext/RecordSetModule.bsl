﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Перем Ошибки;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Таблица = ЭтотОбъект.Выгрузить();
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	Таблица.Период,
	               |	Таблица.НефинансовыйПоказатель,
	               |	Таблица.Сценарий,
	               |	Таблица.Организация,
	               |	Таблица.Подразделение,
	               |	Таблица.Аналитика1,
	               |	Таблица.Аналитика2,
	               |	Таблица.Аналитика3,
	               |	Таблица.Аналитика4,
	               |	Таблица.Аналитика5,
	               |	Таблица.Аналитика6
	               |ПОМЕСТИТЬ ТаблицаНабора
	               |ИЗ
	               |	&Таблица КАК Таблица
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ЗначенияНефинансовыхПоказателей.Период,
	               |	ЗначенияНефинансовыхПоказателей.Регистратор,
	               |	ЗначенияНефинансовыхПоказателей.НефинансовыйПоказатель,
	               |	ЗначенияНефинансовыхПоказателей.Сценарий,
	               |	ЗначенияНефинансовыхПоказателей.Организация,
	               |	ЗначенияНефинансовыхПоказателей.Подразделение,
	               |	ЗначенияНефинансовыхПоказателей.Аналитика1,
	               |	ЗначенияНефинансовыхПоказателей.Аналитика2,
	               |	ЗначенияНефинансовыхПоказателей.Аналитика3,
	               |	ЗначенияНефинансовыхПоказателей.Аналитика4,
	               |	ЗначенияНефинансовыхПоказателей.Аналитика5,
	               |	ЗначенияНефинансовыхПоказателей.Аналитика6
	               |ПОМЕСТИТЬ ТаблицаРегистра
	               |ИЗ
	               |	РегистрСведений.ЗначенияНефинансовыхПоказателей КАК ЗначенияНефинансовыхПоказателей
	               |ГДЕ
	               |	ЗначенияНефинансовыхПоказателей.Регистратор <> &Регистратор
	               |	И (ЗначенияНефинансовыхПоказателей.Период, ЗначенияНефинансовыхПоказателей.НефинансовыйПоказатель, ЗначенияНефинансовыхПоказателей.Сценарий, ЗначенияНефинансовыхПоказателей.Организация, ЗначенияНефинансовыхПоказателей.Подразделение, ЗначенияНефинансовыхПоказателей.Аналитика1, ЗначенияНефинансовыхПоказателей.Аналитика2, ЗначенияНефинансовыхПоказателей.Аналитика3, ЗначенияНефинансовыхПоказателей.Аналитика4, ЗначенияНефинансовыхПоказателей.Аналитика5, ЗначенияНефинансовыхПоказателей.Аналитика6) В
	               |			(ВЫБРАТЬ
	               |				ТаблицаНабора.Период,
	               |				ТаблицаНабора.НефинансовыйПоказатель,
	               |				ТаблицаНабора.Сценарий,
	               |				ТаблицаНабора.Организация,
	               |				ТаблицаНабора.Подразделение,
	               |				ТаблицаНабора.Аналитика1,
	               |				ТаблицаНабора.Аналитика2,
	               |				ТаблицаНабора.Аналитика3,
	               |				ТаблицаНабора.Аналитика4,
	               |				ТаблицаНабора.Аналитика5,
	               |				ТаблицаНабора.Аналитика6
	               |			ИЗ
	               |				ТаблицаНабора)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ЗначенияНефинансовыхПоказателей.Период,
	               |	ЗначенияНефинансовыхПоказателей.Регистратор,
	               |	ЗначенияНефинансовыхПоказателей.НефинансовыйПоказатель,
	               |	ПРЕДСТАВЛЕНИЕ(ЗначенияНефинансовыхПоказателей.НефинансовыйПоказатель),
	               |	ПРЕДСТАВЛЕНИЕ(ЗначенияНефинансовыхПоказателей.Регистратор)
	               |ИЗ
	               |	ТаблицаНабора КАК ТаблицаНабора
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаРегистра КАК ЗначенияНефинансовыхПоказателей
	               |		ПО ТаблицаНабора.Период = ЗначенияНефинансовыхПоказателей.Период
	               |			И ТаблицаНабора.НефинансовыйПоказатель = ЗначенияНефинансовыхПоказателей.НефинансовыйПоказатель
	               |			И ТаблицаНабора.Сценарий = ЗначенияНефинансовыхПоказателей.Сценарий
	               |			И ТаблицаНабора.Организация = ЗначенияНефинансовыхПоказателей.Организация
	               |			И ТаблицаНабора.Подразделение = ЗначенияНефинансовыхПоказателей.Подразделение
	               |			И ТаблицаНабора.Аналитика1 = ЗначенияНефинансовыхПоказателей.Аналитика1
	               |			И ТаблицаНабора.Аналитика2 = ЗначенияНефинансовыхПоказателей.Аналитика2
	               |			И ТаблицаНабора.Аналитика3 = ЗначенияНефинансовыхПоказателей.Аналитика3
	               |			И ТаблицаНабора.Аналитика4 = ЗначенияНефинансовыхПоказателей.Аналитика4
	               |			И ТаблицаНабора.Аналитика5 = ЗначенияНефинансовыхПоказателей.Аналитика5
	               |			И ТаблицаНабора.Аналитика6 = ЗначенияНефинансовыхПоказателей.Аналитика6";
	
	Запрос.УстановитьПараметр("Таблица", Таблица);
	Запрос.УстановитьПараметр("Регистратор", ЭтотОбъект.Отбор.Регистратор.Значение);
	ТаблицаДублей = Запрос.Выполнить().Выгрузить();
	
	ТаблицаДублей.Индексы.Добавить("НефинансовыйПоказатель");
	ТаблицаДублей.Индексы.Добавить("НефинансовыйПоказатель, Регистратор");
	
	МассивНФП = Новый Массив;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивНФП, ТаблицаДублей.ВыгрузитьКолонку("НефинансовыйПоказатель"), Истина);
	Для Каждого НФП из МассивНФП Цикл
		ПредставлениеНФП = ТаблицаДублей.Найти(НФП, "НефинансовыйПоказатель").НефинансовыйПоказательПредставление;
		ТекстСообщения = НСтр("ru = 'Для показателя ""%1"" на даты %2 значения уже установлены документом ""%3""'");
		
		МассивРегистраторов = Новый Массив;
		РегистраторыПоПоказателю = ТаблицаДублей.Скопировать(Новый Структура("НефинансовыйПоказатель", НФП));
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивРегистраторов, РегистраторыПоПоказателю.ВыгрузитьКолонку("Регистратор"), Истина);
		
		Для Каждого Регистратор из МассивРегистраторов Цикл
			
			МассивДат = Новый Массив;
			ДатыПоПоказателю = ТаблицаДублей.Скопировать(Новый Структура("НефинансовыйПоказатель, Регистратор", НФП, Регистратор));
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивДат, ДатыПоПоказателю.ВыгрузитьКолонку("Период"), Истина);
			МассивСвертки = Новый Массив;
			Для Каждого Значение из МассивДат Цикл
				МассивСвертки.Добавить(Формат(Значение, "ДЛФ=D"));
			КонецЦикла;
			ТекстДат = СтрСоединить(МассивДат, ", ");
			ТекстРегистратора = ДатыПоПоказателю[0].РегистраторПредставление;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ПредставлениеНФП, ТекстДат, ТекстРегистратора);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,,ТекстСообщения, "");
			
		КонецЦикла;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
