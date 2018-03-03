﻿////////////////////////////////////////////////////////////////////////////////
// В модуле собраны процедуры и функции, которые вызываются из форм обработки
// "РабочееМестоРаботникаСклада".
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события ПередЗакрытием.
//
// Параметры:
// Форма                - УправляемаяФорма    - форма рабочего места работника склада,
// Отказ                - Булево, Истина      - признак отказа закрытия формы,
// ТекстПредупреждения  - ТекстПредупреждения - текст предупреждения, выводимый пользователю, перед закрытием формы,
// СтандартнаяОбработка - Булево, Истина      - выполняется стандартная, системная обработка закрытия формы.
//
Процедура ПередЗакрытием(Форма, Отказ, ТекстПредупреждения, СтандартнаяОбработка) Экспорт
	
	Элементы = Форма.Элементы;
	ТоварыДляСканирования = Форма.ТоварыДляСканирования;
	МожноЗакрытьФорму = Форма.ПараметрыРежима.МожноЗакрытьФорму;
	ТекущаяСтраница = Форма.Элементы.СтраницыФормы.ТекущаяСтраница;
	
	Если Не МожноЗакрытьФорму Тогда
		
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		
		Если ТекущаяСтраница = Элементы.СтраницаСканирование
			Или ТекущаяСтраница = Элементы.СтраницаВводКоличества
			Или ТекущаяСтраница = Элементы.СтраницаВыборНазначения
			Или ТекущаяСтраница = Элементы.СтраницаВыборЗоныПриемкиОтгрузки
			Или ТоварыДляСканирования.Количество() > 0 Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Выполнение складского задания не завершено.
				|Работа мобильного рабочего места работника склада будет прервана.'");
			
		Иначе
			ТекстПредупреждения = НСтр("ru = 'Работа мобильного рабочего места работника склада будет прервана.'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриЗакрытии.
//
// Параметры:
// Форма - УправляемаяФорма - форма рабочего места работника склада.
//
Процедура ПриЗакрытии(Форма) Экспорт
	
	// МеханизмВнешнегоОборудования
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(Форма);
	// Конец МеханизмВнешнегоОборудования
	
	Если Не Форма.ЭтоПолноправныйПользователь Тогда
		ЗавершитьРаботуСистемы(Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при вводе количества на странице, предназначенной для ручного указания количества отсканированных товаров.
// Осуществляет пересчет значений в полях, предназначенных для ручного указания веса и объема отсканированных товаров.
//
// Параметры:
//	Форма - УправляемаяФорма - форма рабочего места работника склада.
//
Процедура ВводКоличестваКоличествоПриИзменении(Форма) Экспорт
	
	ТекущаяСтрокаСканирования = Форма.ТекущаяСтрокаСканирования;
	
	Если Не (ТекущаяСтрокаСканирования.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"))
		И (ТекущаяСтрокаСканирования.ВесУпаковки <> 0) Тогда
		
		Форма.ВводКоличестваВес = Форма.ВводКоличестваКоличество * ТекущаяСтрокаСканирования.ВесУпаковки
			/ ТекущаяСтрокаСканирования.КоэффициентЕдиницыИзмеренияВеса;
		
	КонецЕсли;
	
	Если Не (ТекущаяСтрокаСканирования.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"))
		И (ТекущаяСтрокаСканирования.ОбъемУпаковки <> 0) Тогда
		
		Форма.ВводКоличестваОбъем = Форма.ВводКоличестваКоличество * ТекущаяСтрокаСканирования.ОбъемУпаковки
			/ ТекущаяСтрокаСканирования.КоэффициентЕдиницыИзмеренияОбъема;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при вводе количества на странице, предназначенной для ручного указания веса отсканированных товаров.
// Осуществляет пересчет значений в полях, предназначенных для ручного указания количества и объема отсканированных 
// товаров.
//
// Параметры:
//	Форма - УправляемаяФорма - форма рабочего места работника склада.
//
Процедура ВводКоличестваВесПриИзменении(Форма) Экспорт
	
	ТекущаяСтрокаСканирования = Форма.ТекущаяСтрокаСканирования;
	
	Форма.ВводКоличестваКоличество = Форма.ВводКоличестваВес * ТекущаяСтрокаСканирования.КоэффициентЕдиницыИзмеренияВеса
		/ ТекущаяСтрокаСканирования.ВесУпаковки;
	
	Если Не (ТекущаяСтрокаСканирования.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"))
		И (ТекущаяСтрокаСканирования.ОбъемУпаковки <> 0) Тогда
		
		Форма.ВводКоличестваОбъем = Форма.ВводКоличестваКоличество * ТекущаяСтрокаСканирования.ОбъемУпаковки
			/ ТекущаяСтрокаСканирования.КоэффициентЕдиницыИзмеренияОбъема;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при вводе количества на странице, предназначенной для ручного указания объема отсканированных товаров.
// Осуществляет пересчет значений в полях, предназначенных для ручного указания количества и веса отсканированных 
// товаров.
//
// Параметры:
//	Форма - УправляемаяФорма - форма рабочего места работника склада.
//
Процедура ВводКоличестваОбъемПриИзменении(Форма) Экспорт
	
	ТекущаяСтрокаСканирования = Форма.ТекущаяСтрокаСканирования;
	
	Форма.ВводКоличестваКоличество = Форма.ВводКоличестваОбъем
		* ТекущаяСтрокаСканирования.КоэффициентЕдиницыИзмеренияОбъема / ТекущаяСтрокаСканирования.ОбъемУпаковки;
	
	Если Не (ТекущаяСтрокаСканирования.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"))
		И (ТекущаяСтрокаСканирования.ВесУпаковки <> 0) Тогда
		
		Форма.ВводКоличестваВес = Форма.ВводКоличестваКоличество * ТекущаяСтрокаСканирования.ВесУпаковки
			/ ТекущаяСтрокаСканирования.КоэффициентЕдиницыИзмеренияВеса;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при выборе команды "ОК" на странице, предназначенной для ручного указания количества отсканированного 
// товара.
// Выполняет подключение процедур, используемых в качестве обработчиков ожидания, после выбора команды "Ок".
//
// Параметры:
//	Форма - УправляемаяФорма - форма рабочего места работника склада.
//
Процедура ВводКоличестваОК(Форма) Экспорт
	
	ТекущееСообщениеПользователю = "";
	
	Если Форма.ПараметрыРежима.ПорядокОбработки = ПредопределенноеЗначение("Перечисление.ПорядокОбработкиСкладскогоЗадания.ЯчейкаТовар") Тогда
		Если Форма.ТекущаяСтрокаСканирования.КоличествоУпаковокОтсканировано = Форма.ВводКоличестваКоличество Тогда
			Если Форма.ТекущаяСтрокаСканирования.НовоеНазначение = Форма.ТекущаяСтрокаСканирования.Назначение Тогда
				Форма.ВводКоличестваОтменен = Истина;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если Форма.ТекущаяСтрокаСканирования.КоличествоУпаковокПоложить = Форма.ВводКоличестваКоличество Тогда
			Форма.ВводКоличестваОтменен = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Форма.ПодключитьОбработчикОжидания("Подключаемый_ВводКоличестваОКОбработчикОжидания", 0.5, Истина);
	Форма.ПодключитьОбработчикОжидания("Подключаемый_ВывестиСостояниеВыполненияЗаданияОбработчикОжидания", 5, Истина);
	
КонецПроцедуры

// Вызывается при выборе команды "Ячейка" на странице, предназначенной для выполнения сканирования товаров 
// складского задания.
// Очищает поле формы "ТекстСообщенияПользователю".
//
// Параметры:
//	Форма - УправляемаяФорма - форма рабочего места работника склада.
//
Процедура СканированиеЯчейка(Форма) Экспорт
	
	ТекстСообщенияПользователю = "";
	
КонецПроцедуры

// Выполняет закрытие формы мобильного рабочего места кладовщика.
//
// Параметры:
//	Форма - УправляемаяФорма - форма рабочего места работника склада.
//
Процедура ЗакрытьФормуМобильногоРабочегоМеста(Форма) Экспорт
	
	Форма.ПараметрыРежима.МожноЗакрытьФорму = Истина;
	Форма.Закрыть();
	
КонецПроцедуры

// Вызывается при выборе команды "ОК" на страницах, предназначенных для ручного указания адреса ячейки, штрихкода 
//товара или номера серии.
// Очищает поле формы "ТекстСообщенияПользователю".
//
// Параметры:
//	Форма - УправляемаяФорма - форма рабочего места работника склада.
//
Процедура ВыборЗначенияОК(Форма) Экспорт
	
	ТекущееСообщениеПользователю = "";
	
КонецПроцедуры

// Вызывается при изменении значения штрихкода на странице, предназначенной для ручного указания адреса ячейки, 
//штрихкода товара или номера серии.
// Выполняет подключение процедур, используемых в качестве обработчиков ожидания.
//
// Параметры:
//	Форма - УправляемаяФорма - форма рабочего места работника склада.
//
Процедура ШтрихкодПараметраСканированияПриИзменении(Форма) Экспорт
	
	Форма.СрокГодностиСерии = "";
	
	Если Не Форма.Элементы.СрокГодностиСерии.Видимость Тогда
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ВыборЗначенияОКОбработчикОжидания", 0.5, Истина);
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ВывестиСостояниеВыполненияЗаданияОбработчикОжидания", 5, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при изменении значения адреса ячейки на странице, предназначенной для ручного указания адреса проблемной 
// ячейки.
// Выполняет подключение процедур, используемых в качестве обработчиков ожидания.
//
// Параметры:
//	Форма - УправляемаяФорма - форма рабочего места работника склада.
//
Процедура АдресЯчейкиПриИзменении(Форма) Экспорт
	
	Форма.ПодключитьОбработчикОжидания("Подключаемый_ВыборАдресаОКОбработчикОжидания", 0.5, Истина);
	
КонецПроцедуры

// Вызывается при изменении значения срока годности серии на странице, предназначенной для ручного указания срока годности 
// серии товара.
// Выполняет подключение процедур, используемых в качестве обработчиков ожидания.
//
// Параметры:
//	Форма - УправляемаяФорма - форма рабочего места работника склада.
//
Процедура СрокГодностиСерииПриИзменении(Форма) Экспорт
	
	Форма.ПодключитьОбработчикОжидания("Подключаемый_ВыборЗначенияОКОбработчикОжидания", 0.5, Истина);
	Форма.ПодключитьОбработчикОжидания("Подключаемый_ВывестиСостояниеВыполненияЗаданияОбработчикОжидания", 5, Истина);
	
КонецПроцедуры

// Выполняет обновление списка складских заданий на странице, предназнченной для выбора задания.
//
// Параметры:
//	Форма - УправляемаяФорма - форма рабочего места работника склада.
//
Процедура ЗаданияОбновить(Форма) Экспорт
	
	Форма.Элементы.Задания.Обновить();
	
КонецПроцедуры

// Определяет необходимость обновления списка складских заданий.
//
// Параметры:
//  Форма - УправляемаяФорма - форма рабочего места работника склада.
//
// Возвращаемое значение:
//  Булево - Истина, признак того, что требуется обновить список складских заданий.
//
Функция НужноОбновитьСписокЗаданий(Форма) Экспорт
	
	Возврат Форма.Элементы.СтраницыФормы.ТекущаяСтраница = Форма.Элементы.СтраницаВыборОперации
		Или Форма.Элементы.СтраницыФормы.ТекущаяСтраница = Форма.Элементы.СтраницаВыборЗадания;
	
КонецФункции

// Определяет необходимость обновления статуса состояния выполнения складского задания.
//
// Параметры:
//  Форма - УправляемаяФорма - форма рабочего места работника склада.
//
// Возвращаемое значение:
//  Булево - Истина, признак того, что требуется обновить статус состояния выполнения складского задания.
//
Функция НужноОбновитьСостояниеВыполненияЗадания(Форма) Экспорт
	
	Возврат Форма.Элементы.СтраницыФормы.ТекущаяСтраница = Форма.Элементы.СтраницаСканирование;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
