﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыПланов[НовыйСтатус];
	
	Статус = ЗначениеНовогоСтатуса;
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	//++ НЕ УТКА
	ПроверитьНаличиеБюджетнойЗадачи(Отказ);
	//-- НЕ УТКА

	ПараметрыОпции = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУтверждениеБюджетов", ПараметрыОпции) Тогда
		Статус = Перечисления.СтатусыПланов.Утвержден;
	КонецЕсли;
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ЭкземплярБюджета.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по регистрам
	РегистрыНакопления.ОборотыБюджетов.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидБюджета, "ПроводитьЭкземплярыБюджетовОтложено") Тогда
		БюджетированиеСервер.ПоставитьДокументВОчередьПроведения(Ссылка);
		БюджетированиеСервер.ЗапуститьОтложенноеПроведениеФоновымЗаданием(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	СтруктураПараметров = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	
	Если Не ПолучитьФункциональнуюОпцию("ФормироватьБюджетыПоОрганизациям", СтруктураПараметров) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ФормироватьБюджетыПоПодразделениям", СтруктураПараметров) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Подразделение");
	КонецЕсли;
	
	ИспользоватьУтверждениеБюджетов = ПолучитьФункциональнуюОпцию("ИспользоватьУтверждениеБюджетов", СтруктураПараметров);

	Если ИспользоватьУтверждениеБюджетов
		И (Статус = Перечисления.СтатусыПланов.Утвержден ИЛИ Не ЗначениеЗаполнено(Ссылка) 
		ИЛИ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Статус") = Перечисления.СтатусыПланов.Утвержден) Тогда
		
		Если Не ПраваПользователяПовтИсп.УтверждениеЭкземпляровБюджетов() Тогда
			Если Статус = Перечисления.СтатусыПланов.Утвержден Тогда
				ТекстОшибки = НСтр("ru='Нет доступа на утверждение экземпляров бюджетов.'");
			Иначе
				ТекстОшибки = НСтр("ru='Нет доступа на изменение утвержденных экземпляров бюджетов.'");
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				, // Поле
				, // ПутьКДанным
				Отказ);
		КонецЕсли;
	КонецЕсли;
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("НачалоПериода") Тогда
		НачалоПериода = ДанныеЗаполнения.НачалоПериода;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ОкончаниеПериода") Тогда
		ОкончаниеПериода = ДанныеЗаполнения.ОкончаниеПериода;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ВидБюджета") Тогда
		ВидБюджета = ДанныеЗаполнения.ВидБюджета;
		МодельБюджетирования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидБюджета, "Владелец");
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Сч = 1;
		Пока Сч <=6 Цикл
			Если ДанныеЗаполнения.Свойство("Аналитика" + Сч) Тогда
				ЭтотОбъект["Аналитика" + Сч] = ДанныеЗаполнения["Аналитика" + Сч];
			КонецЕсли;
			Сч = Сч + 1;
		КонецЦикла;
	КонецЕсли;

	
	Если Не ЗначениеЗаполнено(НачалоПериода) ИЛИ Не ЗначениеЗаполнено(ОкончаниеПериода) Тогда
		
		ТекущаяДата = ТекущаяДатаСеанса();
		Если Не ЗначениеЗаполнено(НачалоПериода) Тогда
			НачалоПериода = ТекущаяДата;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ОкончаниеПериода) Тогда
			ОкончаниеПериода = ТекущаяДата;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВидБюджета) Тогда
			Справочники.ВидыБюджетов.ВыровнятьДатыПоПериодичностиБюджета(ВидБюджета, НачалоПериода, ОкончаниеПериода);
		КонецЕсли;
		
	КонецЕсли;
	
	ГраницаФактДанных = Справочники.ВидыБюджетов.ГраницаФактическихДанныхПоВидуБюджета(ВидБюджета, НачалоПериода);
	
	Если Не ЗначениеЗаполнено(МодельБюджетирования) Тогда
		МодельБюджетирования = Справочники.МоделиБюджетирования.МодельБюджетированияПоУмолчанию();
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

//++ НЕ УТКА
Процедура ПроверитьНаличиеБюджетнойЗадачи(Отказ)
	
	Если ДополнительныеСвойства.Свойство("БюджетнаяЗадача") И ЗначениеЗаполнено(ДополнительныеСвойства.БюджетнаяЗадача) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("МодельБюджетирования", МодельБюджетирования);

	ИспользоватьБюджетныйПроцесс = ПолучитьФункциональнуюОпцию("ИспользоватьБюджетныйПроцесс", СтруктураПараметров);

	Если ИспользоватьБюджетныйПроцесс И НЕ РольДоступна("РедактированиеДанныхБюджетированияВнеПроцессов")
		И НЕ Пользователи.ЭтоПолноправныйПользователь(, , Истина) Тогда
		
		Если Не ЗначениеЗаполнено(Ссылка) Тогда
			ТекстОшибки = НСтр("ru='Создание документа возможно только из бюджетной задачи.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				, // Поле
				, // ПутьКДанным
				Отказ);
		Иначе	
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	БюджетнаяЗадачаСписокДокументов.Ссылка
			               |ИЗ
			               |	Задача.БюджетнаяЗадача.СписокДокументов КАК БюджетнаяЗадачаСписокДокументов
			               |ГДЕ
			               |	БюджетнаяЗадачаСписокДокументов.Документ = &Документ
			               |	И НЕ БюджетнаяЗадачаСписокДокументов.Ссылка.Выполнена
			               |	И БюджетнаяЗадачаСписокДокументов.Ссылка.Исполнитель = &Исполнитель";
						   
			Запрос.УстановитьПараметр("Документ", Ссылка);
			Запрос.УстановитьПараметр("Исполнитель", Пользователи.ТекущийПользователь());
						   
			Если Запрос.Выполнить().Пустой() Тогда
				ТекстОшибки = НСтр("ru='Изменения запрещены, т.к. нет активной бюджетной задачи.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					, // Поле
					, // ПутьКДанным
					Отказ);
					   
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
//-- НЕ УТКА

#КонецОбласти

#КонецЕсли
